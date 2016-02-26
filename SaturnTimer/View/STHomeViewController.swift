//
//  ViewController.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/19/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit
import QorumLogs

enum PlayButtonActionType: Int {
  case None, StartTimer, PauseTimer
}

enum RigthBottomButtonActionType: Int {
  case None, StopTimer, MenuAction
}

class STHomeViewController: STViewController {
  private var viewModel: STHomeViewModel!

  var dialPlateView: STDialPlateView!
  
  @IBOutlet weak var layoutConstraintHourView: NSLayoutConstraint!
  @IBOutlet weak var layoutConstraintSecondView: NSLayoutConstraint!
  
  @IBOutlet weak var hourItemView: UIView!
  @IBOutlet weak var secondItemView: UIView!
  
  @IBOutlet weak var hourLabel: UILabel!
  @IBOutlet weak var minuteLabel: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  
  @IBOutlet weak var bottomButton: UIButton!
  
  private var playButtonAction: CocoaAction!
  private var rightBottomButtonAction: CocoaAction!
  
  let widthOfTimeItem: CGFloat = 60
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    bindViewModel()
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    HelperNotification.askForNotificationPermission()
  }
  
  func bindViewModel () {
    viewModel = STHomeViewModel()
    
    viewModel.timeChangeSignal
      .observeOn(UIScheduler())
      .observeNext {[weak self] (time) -> () in
        self?.hourLabel.text = time.hour < 10 ? "0\(time.hour)" : "\(time.hour)"
        self?.minuteLabel.text = time.minute < 10 ? "0\(time.minute)" : "\(time.minute)"
        self?.secondLabel.text = time.second < 10 ? "0\(time.second)" : "\(time.second)"
    }
    
    viewModel.timeValidSignal
      .observeOn(UIScheduler())
      .combinePrevious(false)
      .observeNext { (oldValid, newValid) -> () in
        if newValid != oldValid {
          self.dialPlateView.playButton.enabled = newValid
        }
    }
    
    viewModel.timeTikTokSignal
      .observeOn(UIScheduler())
      .observeNext {[weak self] (time) -> () in
        let minuteProgress = Double(time.minute) / 60.0 + Double(time.second) / 3600.0
        self?.dialPlateView.slideMinuteSliderToProgress(minuteProgress, duration: 0.9)

        if time.hour > 0 {
          let hourProgress = Double(time.hour) / 12.0 + Double(time.minute) / 720.0
          self?.dialPlateView.slideHourSliderToProgress(hourProgress, duration: 0.9)
        }
        else {
          self?.dialPlateView.slideHourSliderToProgress(0.0, duration: 0.9)
        }
    }
    
    viewModel.playing
      .producer
      .observeOn(UIScheduler())
      .startWithNext {[weak self] (playing) -> () in
        guard let _self = self else {return}
        UIView.beginAnimations("Time Item Animation", context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationCurve(.EaseInOut)
        if playing {
          if _self.viewModel.hour.value == 0 {
            _self.layoutConstraintHourView.constant = 0
            _self.hourItemView.alpha = 0.0
          }
          else {
            _self.layoutConstraintHourView.constant = _self.widthOfTimeItem
            _self.hourItemView.alpha = 1.0
          }
          _self.layoutConstraintSecondView.constant = _self.widthOfTimeItem
          _self.secondItemView.alpha = 1.0
        }
        else {
          _self.layoutConstraintHourView.constant = _self.widthOfTimeItem
          _self.layoutConstraintSecondView.constant = 0
          _self.hourItemView.alpha = 1.0
          _self.secondItemView.alpha = 0.0
        }
        _self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
        _self.dialPlateView.enableSlider(!playing)
        _self.dialPlateView.changePlayButtonAppearence(playing)
    }
    
//    viewModel.pausing
//      .producer
//      .observeOn(UIScheduler())
//      .startWithNext {[weak self] (pausing) -> () in
////        QL1("pausing: \(pausing)")
//    }
//    
//    viewModel.playButtonAction
//      .events
//      .observeNext { (event) -> () in
//        switch event {
//        case let .Next(value):
//          break
//        default:
//          break
//        }
//    }
//    
    viewModel.rightBottomButtonAction
      .events
      .observeNext { (event) -> () in
    }
    
    
    playButtonAction = CocoaAction(viewModel.playButtonAction, { _ in return () })
    rightBottomButtonAction = CocoaAction(viewModel.rightBottomButtonAction, {_ in return ()})
    
    
    dialPlateView.playButton.pressedSignalProducer().startWithNext {[weak self] () -> () in
      self?.playButtonAction.execute(nil)
    }
    
  }
  
  func configView () {
    dialPlateView = STDialPlateView()
    view.addSubview(dialPlateView)
    
    dialPlateView.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(15)
      make.right.equalTo(-15)
      make.top.equalTo(237)
      make.width.equalTo(dialPlateView.snp_height).multipliedBy(1.0)
    }
    
    dialPlateView.configView()
    
    dialPlateView.hourSlider.progress
      .producer
      .observeOn(QueueScheduler.mainQueueScheduler)
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .startWithNext {[weak self] (progress) -> () in
        let hour: Int = Int(floor(12 * progress)) % 12
        self?.viewModel.hour.value = hour
    }
  
    dialPlateView.minuteSlider.progress
      .producer
      .observeOn(QueueScheduler.mainQueueScheduler)
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .startWithNext {[weak self] (progress) -> () in
        let minute: Int = Int(floor(60 * progress))
        self?.viewModel.minute.value = minute
    }
    
    dialPlateView.touchEndSignal
      .observeOn(UIScheduler())
      .observeNext {[weak self] () -> () in
        guard let _self = self else {return}
        if _self.viewModel.hour.value == 0 {
          _self.dialPlateView.slideHourSliderToProgress(0.0, duration: 0.5)
        }
        if _self.viewModel.minute.value == 0 {
          _self.dialPlateView.slideMinuteSliderToProgress(0.0, duration: 0.5)
        }
    }
    
    layoutConstraintSecondView.constant = 0
    view.layoutIfNeeded()
  }
  
  @IBAction func bottomButtonPressed(sender: UIButton) {
    if viewModel.playing.value {      //Stop the timer
      dialPlateView.playButton.highlighting = false
      dialPlateView.slideSlidersToProgress(0.0, duration: 1.0)
    }
    rightBottomButtonAction.execute(nil)
  }
}

