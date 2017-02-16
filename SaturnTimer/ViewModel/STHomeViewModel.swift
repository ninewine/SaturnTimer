//
//  STHomeViewModel.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import QorumLogs

class STHomeViewModel: STViewModel {
  
  //Input
  let hour = MutableProperty<Int>(0)
  let minute = MutableProperty<Int>(0)
  let second = MutableProperty<Int>(0)
  
  let tagType = MutableProperty<STTagType>(STTagType.SaturnType)
  let soundFileName = MutableProperty<String>(UILocalNotificationDefaultSoundName)
  
  //Output
  let timeChangeSignal: Signal<STTime, NoError>
  let timeValidSignal: Signal<Bool, NoError>
  let timeTikTokSignal: Signal<STTime, NoError>
  
  let playing = MutableProperty<Bool>(false)
  let pausing = MutableProperty<Bool>(false)
  
  //Action
  
  lazy var playButtonAction: Action<Void, PlayButtonActionType, NoError> = {
    return Action({[weak self] _ in
      guard let _self = self else {return SignalProducer(value: PlayButtonActionType.none)}
      if _self.playing.value {
        if _self.pausing.value{
          _self.pausing.value = false
          _self.fireTimer(nil)
          return SignalProducer(value: PlayButtonActionType.startTimer)
        }
        else {
          _self.pausing.value = true
          _self.pauseTimer()
          return SignalProducer(value: PlayButtonActionType.pauseTimer)
        }
      }
      else {
        _self.playing.value = true
        _self.fireTimer(nil)
        return SignalProducer(value: PlayButtonActionType.startTimer)
      }
    })
  }()
  
  lazy var actionButtonAction: Action<Void, RigthBottomButtonActionType, NoError> = {
    return Action({[weak self] _ in
      guard let _self = self else {return SignalProducer(value: RigthBottomButtonActionType.none)}
      
      if _self.playing.value {
        _self.playing.value = false
        _self.pausing.value = false
        _self.invalidateTimer(clean: true)
        return SignalProducer(value: RigthBottomButtonActionType.stopTimer)
      }
      else {
        return SignalProducer(value: RigthBottomButtonActionType.menuAction)
      }
    })
  }()

  
  //Private
  
  fileprivate let timeChangeObserver: Observer<STTime, NoError>
  fileprivate let timeValidObserver: Observer<Bool, NoError>
  fileprivate let timeTikTokObserver: Observer<STTime, NoError>

  fileprivate var time : STTime
  fileprivate var timer : STTimer?
  fileprivate var timerDisposable: Disposable?
  
  
  //Lifecircle
  //Lifecircle

  override init () {
    if let fileName = UserDefaults.standard.string(forKey: HelperConstant.UserDefaultKey.CurrentSoundFileName) {
      soundFileName.value = fileName
    }
    
    if let typeName = UserDefaults.standard.string(forKey: HelperConstant.UserDefaultKey.CurrentTagTypeName) {
      if let type = STTagType(rawValue: typeName) {
        tagType.value = type
      }
    }
    
    time = STTime(hour: 0, minute: 0, second: 0)
  
    let (timeChangeSignal, timeChangeObserver) = Signal<STTime, NoError>.pipe()
    self.timeChangeSignal = timeChangeSignal
    self.timeChangeObserver = timeChangeObserver
    
    let (timeValidSignal, timeValidObserver) = Signal<Bool, NoError>.pipe()
    self.timeValidSignal = timeValidSignal
    self.timeValidObserver = timeValidObserver
    
    let (timeTikTokSignal, timeTikTokObserver) = Signal<STTime, NoError>.pipe()
    self.timeTikTokSignal = timeTikTokSignal
    self.timeTikTokObserver = timeTikTokObserver
    
    super.init()
    
    hour
      .producer
      .filter { (hour) -> Bool in
        return hour >= 0 && hour <= 12
      }
      .combinePrevious(-1)
      .startWithValues {[weak self] (oldHour, newHour) -> () in
        guard let _self = self else {return}
        if newHour != oldHour {
          _self.time.hour = newHour
          timeChangeObserver.send(value: _self.time)
          timeValidObserver.send(value: _self.time.isValid())
        }
    }
    
    minute
      .producer
      .filter { (minute) -> Bool in
        return minute >= 0 && minute <= 60
      }
      .combinePrevious(-1)
      .startWithValues {[weak self] (oldMinute, newMinute) -> () in
        guard let _self = self else {return}
        if newMinute != oldMinute {
          _self.time.minute = newMinute
          timeChangeObserver.send(value: _self.time)
          timeValidObserver.send(value: _self.time.isValid())
        }
    }
    
    second
      .producer
      .filter { (second) -> Bool in
        return second >= 0 && second <= 60
      }
      .combinePrevious(-1)
      .startWithValues {[weak self] (oldSecond, newSecond) -> () in
        guard let _self = self else {return}
        if newSecond != oldSecond {
          _self.time.second = newSecond
          timeChangeObserver.send(value: _self.time)
          timeValidObserver.send(value: _self.time.isValid())
        }
    }
    
    tagType
      .producer
      .observe(on: UIScheduler())
      .startWithValues { (type) -> () in
        UserDefaults.standard.set(type.rawValue, forKey: HelperConstant.UserDefaultKey.CurrentTagTypeName)
    }
    
    soundFileName
      .producer
      .observe(on: UIScheduler())
      .startWithValues { (fileName) -> () in
        UserDefaults.standard.set(fileName, forKey: HelperConstant.UserDefaultKey.CurrentSoundFileName)
    }

    self.registerNotification()
  }
  
  func registerNotification () {
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationDidEnterBackground)
      .take(during: reactive.lifetime)
      .observeValues({[weak self] (notification) in
        self?.applicationDidEnterBackground()
    })
    
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationDidBecomeActive)
      .take(during: reactive.lifetime)
      .observeValues({[weak self] (notification) in
        self?.applicationDidBecomeActive()
    })
  }
  
  func applicationDidEnterBackground () {
    if self.playing.value {
      self.invalidateTimer(clean:false)
    }
  }
  
  func applicationDidBecomeActive () {
    if !pausing.value {
      let (exist, notification) = scheduledNotificationExist()
      if exist {
        if let noti = notification {
          refreshRemainingTime(noti)
        }
      }
      else {
        if playing.value {
          invalidateTimer(clean: true)
          playing.value = false
//          timeValidObserver.sendNext(true)
          timeTikTokObserver.send(value: time)
        }
      }
    }
  }
  
  //MARK - Timer
  func convertTimeInterval (_ ti : TimeInterval) -> (hour: Int, minute: Int, second: Int) {
    let hour = Int(floor(ti / 3600.0))
    let minute = Int(floor((ti - Double(hour * 3600)) / 60.0))
    let second = Int(ti - Double(hour * 3600) - Double(minute * 60))
    return (hour, minute, second)
  }
  
  func refreshRemainingTime(_ notification: UILocalNotification) {
    if let fireDate = notification.fireDate {
      let remainingTimeInterval = fireDate.timeIntervalSince(Date())
      let ti = TimeInterval(lround(remainingTimeInterval))
      if ti > 0 {
        invalidateTimer(clean: true)
        fireTimer(ti)
        if !playing.value {
          playing.value = true
        }
        pausing.value = false
      }
      else {
        playing.value = false
        pausing.value = false
      }
    }
  }
  
  func fireTimer (_ remainingTime: TimeInterval?) {
    var time: TimeInterval = 0.0
    if remainingTime != nil {
      time = remainingTime!
    }
    else {
      time = TimeInterval(hour.value * 3600 + minute.value * 60 + second.value)
    }
    if timer == nil {
      timer = STTimer(remainingTime: time)
      timerDisposable =
        DynamicProperty<Any>(object: timer!, keyPath: "remainingTime")
          .signal
          .observe(on: UIScheduler())
          .observeValues {[weak self] (timeInterval) -> () in
            guard let _self = self else {return}
            if let ti = timeInterval as? TimeInterval {
              let (hour, minute, second) = _self.convertTimeInterval(ti)
              _self.hour.value = hour
              _self.minute.value = minute
              _self.second.value = second
              _self.timeTikTokObserver.send(value: _self.time)
              if hour == 0 && minute == 0 && second == 0 {
                _self.playing.value = false
                _self.pausing.value = false
                if !HelperNotification.isAccessible() {
                  STTimerNotification.shareInstance.showNotificationWithString(_self.tagType.value.tagTypeTimeIsUpString())
                  STTimerNotification.shareInstance.playSoundWithFileName(_self.soundFileName.value)
                }
              }
            }
      }
    }
    else {
      timer?.remainingTime = time
    }

    timer?.fire()
    generateNotification(time)
  }
  
  func pauseTimer () {
    timer?.pause()
    cancelNotification()
  }
  
  func invalidateTimer (clean: Bool) {
    timer?.invalidate()
    timer = nil
    timerDisposable?.dispose()
    timerDisposable = nil

    if clean {
      hour.value = 0
      minute.value = 0
      second.value = 0
      cancelNotification()
    }
  }
  
  //MARK: - Notification
  func scheduledNotificationExist () -> (exist: Bool, notification: UILocalNotification?) {
    if let notifications = UIApplication.shared.scheduledLocalNotifications, notifications.count > 0 {
      let notification = notifications[0]
      return (true, notification)
    }
    return (false, nil)
  }
  
  func generateNotification (_ remainingTime: TimeInterval) {
    let date = Date().addingTimeInterval(remainingTime)
    let notification = UILocalNotification()
    notification.timeZone = TimeZone.current
    notification.soundName = soundFileName.value
    notification.alertBody = tagType.value.tagTypeTimeIsUpString()
    notification.fireDate = date
    UIApplication.shared.scheduleLocalNotification(notification)
  }

  func cancelNotification () {
    UIApplication.shared.cancelAllLocalNotifications()
  }
}





