//
//  STHomeViewModel.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import ReactiveCocoa
import Result
import QorumLogs

class STHomeViewModel: STViewModel {
  
  //Input
  let hour = MutableProperty<Int>(0)
  let minute = MutableProperty<Int>(0)
  let second = MutableProperty<Int>(0)
  
  //Output
  let timeChangeSignal: Signal<STTime, NoError>
  let timeValidSignal: Signal<Bool, NoError>
  let timeTikTokSignal: Signal<STTime, NoError>
  
  let playing = MutableProperty<Bool>(false)
  let pausing = MutableProperty<Bool>(false)
  
  //Action
  
  lazy var playButtonAction: Action<Void, PlayButtonActionType, NoError> = {
    return Action({[weak self] _ in
      guard let _self = self else {return SignalProducer(value: PlayButtonActionType.None)}
      if _self.playing.value {
        if _self.pausing.value{
          _self.pausing.value = false
          _self.fireTimer(nil)
          return SignalProducer(value: PlayButtonActionType.StartTimer)
        }
        else {
          _self.pausing.value = true
          _self.pauseTimer()
          return SignalProducer(value: PlayButtonActionType.PauseTimer)
        }
      }
      else {
        _self.playing.value = true
        _self.fireTimer(nil)
        return SignalProducer(value: PlayButtonActionType.StartTimer)
      }
    })
  }()
  
  lazy var rightBottomButtonAction: Action<Void, RigthBottomButtonActionType, NoError> = {
    return Action({[weak self] _ in
      guard let _self = self else {return SignalProducer(value: RigthBottomButtonActionType.None)}
      
      if _self.playing.value {
        _self.playing.value = false
        _self.pausing.value = false
        _self.invalidateTimer(clean: true)
        return SignalProducer(value: RigthBottomButtonActionType.StopTimer)
      }
      else {
        return SignalProducer(value: RigthBottomButtonActionType.MenuAction)
      }
    })
  }()

  
  //Private
  
  private let timeChangeObserver: Observer<STTime, NoError>
  private let timeValidObserver: Observer<Bool, NoError>
  private let timeTikTokObserver: Observer<STTime, NoError>

  private var time : STTime
  private var timer : STTimer?
  private var timerDisposable: Disposable?
  
  override init () {
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
      .startWithNext {[weak self] (oldHour, newHour) -> () in
        guard let _self = self else {return}
        if newHour != oldHour {
          _self.time.hour = newHour
          timeChangeObserver.sendNext(_self.time)
          timeValidObserver.sendNext(_self.time.isValid())
        }
    }
    
    minute
      .producer
      .filter { (minute) -> Bool in
        return minute >= 0 && minute <= 60
      }
      .combinePrevious(-1)
      .startWithNext {[weak self] (oldMinute, newMinute) -> () in
        guard let _self = self else {return}
        if newMinute != oldMinute {
          _self.time.minute = newMinute
          timeChangeObserver.sendNext(_self.time)
          timeValidObserver.sendNext(_self.time.isValid())
        }
    }
    
    second
      .producer
      .filter { (second) -> Bool in
        return second >= 0 && second <= 60
      }
      .combinePrevious(-1)
      .startWithNext {[weak self] (oldSecond, newSecond) -> () in
        guard let _self = self else {return}
        if newSecond != oldSecond {
          _self.time.second = newSecond
          timeChangeObserver.sendNext(_self.time)
          timeValidObserver.sendNext(_self.time.isValid())
        }
    }

    self.registerNotification()
  }
  
  func registerNotification () {
    NSNotificationCenter
      .defaultCenter()
      .rac_addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil)
      .takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.applicationDidEnterBackground()
    }
    
    NSNotificationCenter
      .defaultCenter()
      .rac_addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil)
      .takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.applicationDidBecomeActive()
    }
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
          timeValidObserver.sendNext(true)
          timeTikTokObserver.sendNext(time)
        }
      }
    }
  }
  
  //MARK - Timer
  func convertTimeInterval (ti : NSTimeInterval) -> (hour: Int, minute: Int, second: Int) {
    let hour = Int(floor(ti / 3600.0))
    let minute = Int(floor((ti - Double(hour * 3600)) / 60.0))
    let second = Int(ti - Double(hour * 3600) - Double(minute * 60))
    return (hour, minute, second)
  }
  
  func refreshRemainingTime(notification: UILocalNotification) {
    if let fireDate = notification.fireDate {
      let remainingTimeInterval = fireDate.timeIntervalSinceDate(NSDate())
      let ti = NSTimeInterval(lround(remainingTimeInterval))
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
  
  func fireTimer (remainingTime: NSTimeInterval?) {
    var time: NSTimeInterval = 0.0
    if remainingTime != nil {
      time = remainingTime!
    }
    else {
      time = NSTimeInterval(hour.value * 3600 + minute.value * 60 + second.value)
    }
    if timer == nil {
      timer = STTimer(remainingTime: time)
      timerDisposable =
        DynamicProperty(object: timer!, keyPath: "remainingTime")
          .signal
          .observeOn(UIScheduler())
          .observeNext {[weak self] (timeInterval) -> () in
            guard let _self = self else {return}
            if let ti = timeInterval as? NSTimeInterval {
              let (hour, minute, second) = _self.convertTimeInterval(ti)
              _self.hour.value = hour
              _self.minute.value = minute
              _self.second.value = second
              _self.timeTikTokObserver.sendNext(_self.time)
              if hour == 0 && minute == 0 && second == 0 {
                _self.playing.value = false
                _self.pausing.value = false
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
  
  func invalidateTimer (clean clean: Bool) {
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
    if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications where notifications.count > 0 {
      let notification = notifications[0]
      return (true, notification)
    }
    return (false, nil)
  }
  
  func generateNotification (remainingTime: NSTimeInterval) {
    let date = NSDate().dateByAddingTimeInterval(remainingTime)
    let notification = UILocalNotification()
    notification.timeZone = NSTimeZone.defaultTimeZone()
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.alertBody = "时间到了"
    notification.fireDate = date
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }

  func cancelNotification () {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
}





