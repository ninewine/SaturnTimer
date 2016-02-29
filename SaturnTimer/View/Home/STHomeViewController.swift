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
import GPUImage

enum PlayButtonActionType: Int {
  case None, StartTimer, PauseTimer
}

enum RigthBottomButtonActionType: Int {
  case None, StopTimer, MenuAction
}

class STHomeViewController: STViewController {
  private var viewModel: STHomeViewModel!

  var dialPlateView: STDialPlateView!
  
  @IBOutlet weak var layoutConstraintWidthHourView: NSLayoutConstraint!
  @IBOutlet weak var layoutConstraintWidthSecondView: NSLayoutConstraint!
  @IBOutlet weak var layoutConstraintTopTagContentView: NSLayoutConstraint!
  
  @IBOutlet weak var tagContentView: UIView!
  @IBOutlet weak var hourItemView: UIView!
  @IBOutlet weak var secondItemView: UIView!
  
  @IBOutlet weak var hourLabel: UILabel!
  @IBOutlet weak var minuteLabel: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  
  @IBOutlet weak var actionButton: STActionButton!
  
  private var menuViewController: STMenuViewController!
  
  private var playButtonAction: CocoaAction!
  private var actionButtonAction: CocoaAction!
  
  let widthOfTimeItem: CGFloat = 60
  
  
  //MARK: - Lifecircle
  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    bindViewModel()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    HelperNotification.askForNotificationPermission()
  }
  
  func configView () {
    dialPlateView = STDialPlateView()
    view.insertSubview(dialPlateView, belowSubview: actionButton)
    
    dialPlateView.snp_makeConstraints { (make) -> Void in
      let leftRightMargin = HelperCommon.currentDeviceType == .iPad ? 180 : 15
      let topMargin =
      HelperCommon.currentDeviceType == .iPad
        ? 370
        : HelperCommon.currentDeviceType == .iPhone4 ? 180 : 220
      
      make.left.equalTo(leftRightMargin)
      make.right.equalTo(-leftRightMargin)
      make.top.equalTo(topMargin)
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
    
    actionButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext {[weak self] (button) -> Void in
      guard let btn = button as? STActionButton else {return}
      
      switch btn.type {
      case .Menu:
        self?.openSettingsAction()
        break
      case .Stop:
        self?.stopTimerAction()
        break
      case .Close:
        self?.closeSettingsAction()
        break
      default:
        break
      }
    }
    
    configTagView()
    
    layoutConstraintWidthSecondView.constant = 0
    
    if HelperCommon.currentDeviceType == .iPhone4 {
      layoutConstraintTopTagContentView.constant = 30.0
    }
    else if HelperCommon.currentDeviceType == .iPad {
      layoutConstraintTopTagContentView.constant = 150.0
    }
    
    view.layoutIfNeeded()
  }
  
  func configTagView () {
    if let tagTypeName = NSUserDefaults.standardUserDefaults().stringForKey(HelperConstant.UserDefaultKey.CurrentTagTypeName) {
      if let TagClass = STTagType.animatableTagClass(tagTypeName) as? AnimatableTag.Type {
        for view in tagContentView.subviews {
          view.removeFromSuperview()
        }
        let tag = TagClass.init(frame:CGRect(x: 0, y: 0, width: tagContentView.frame.width, height: tagContentView.frame.height))
        tag.setHighlightStatus(true, animated: true)
        tagContentView.addSubview(tag)
      }
    }
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
            _self.layoutConstraintWidthHourView.constant = 0
            _self.hourItemView.alpha = 0.0
          }
          else {
            _self.layoutConstraintWidthHourView.constant = _self.widthOfTimeItem
            _self.hourItemView.alpha = 1.0
          }
          _self.layoutConstraintWidthSecondView.constant = _self.widthOfTimeItem
          _self.secondItemView.alpha = 1.0
        }
        else {
          _self.layoutConstraintWidthHourView.constant = _self.widthOfTimeItem
          _self.layoutConstraintWidthSecondView.constant = 0
          _self.hourItemView.alpha = 1.0
          _self.secondItemView.alpha = 0.0
        }
        _self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
        _self.dialPlateView.enableSlider(!playing)
        _self.dialPlateView.changePlayButtonAppearence(playing)
        
        _self.actionButton.type = playing ? .Stop : .Menu
    }
    
    viewModel.tagType
      .signal
      .observeOn(UIScheduler())
      .combinePrevious(.SaturnType)
      .observeNext {[weak self] (oldType, newType) -> () in
        if newType != oldType {
          self?.configTagView()
        }
    }
    
    viewModel.actionButtonAction
      .events
      .observeNext { (event) -> () in
    }
    
    
    playButtonAction = CocoaAction(viewModel.playButtonAction, { _ in return () })
    actionButtonAction = CocoaAction(viewModel.actionButtonAction, {_ in return ()})
    
    
    dialPlateView.playButton.pressedSignalProducer().startWithNext {[weak self] () -> () in
      self?.playButtonAction.execute(nil)
    }
    
  }
  
  //MARK: - Actions
  
  func stopTimerAction() {
    if viewModel.playing.value {      //Stop the timer
      dialPlateView.playButton.highlighting = false
      dialPlateView.slideSlidersToProgress(0.0, duration: 1.0)
    }
    actionButtonAction.execute(nil)
  }
  
  func openSettingsAction () {
    actionButton.type = .Close
    
    if menuViewController == nil {
      if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(STMenuViewController.classString()) as? STMenuViewController {
        if let image = screenshotWithBlurEffect() {
          viewController.view.layer.contents = image.CGImage
        }
        viewController.bindViewModelToHomeViewModel(viewModel)
        viewController.actionButton = self.actionButton
        viewController.view.alpha = 0.0
        viewController.willMoveToParentViewController(self)
        view.insertSubview(viewController.view, belowSubview: actionButton)
        viewController.didMoveToParentViewController(self)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
          viewController.view.alpha = 1.0
          }) {(flag) -> Void in
            viewController.didMoveToParentViewController(self)
        }
        menuViewController = viewController

      }
    }
  }
  
  func closeSettingsAction () {
    if actionButton.type == .Back {
      //Close Change Sounds View, proceeding in STMenuViewController
      return
    }
    
    actionButton.type = .Menu

    if menuViewController != nil {
      menuViewController.willMoveToParentViewController(nil)
      UIView.animateWithDuration(0.2, animations: { () -> Void in
        self.menuViewController.view.alpha = 0.0
        }, completion: { (flag) -> Void in
          self.menuViewController.view.removeFromSuperview()
          self.menuViewController.didMoveToParentViewController(nil)
          self.menuViewController = nil
      })
    }
  }
  
  
  
  func screenshotWithBlurEffect () -> UIImage? {
    let screenBounds = UIScreen.mainScreen().bounds
    let screenScale = UIScreen.mainScreen().scale
    
    UIGraphicsBeginImageContextWithOptions(screenBounds.size, true, screenScale)
    var screenshot: UIImage?
    if let context = UIGraphicsGetCurrentContext() {
      view.window?.layer.renderInContext(context)
      screenshot = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()

    //resize
    let size = CGSize(width: screenBounds.width / screenScale, height: screenBounds.height / screenScale)
    UIGraphicsBeginImageContext(size)
    screenshot?.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let blurImageSource = GPUImagePicture(image: image)
    
    let blurImageFillter = GPUImageGaussianBlurFilter() // GPUImageiOSBlurFilter()
    blurImageFillter.forceProcessingAtSize(screenBounds.size)
    blurImageFillter.blurRadiusInPixels = 12
    blurImageSource.addTarget(blurImageFillter)
    blurImageFillter.useNextFrameForImageCapture()
    blurImageSource.processImage()
    
    let outputImage = blurImageFillter.imageFromCurrentFramebuffer()
    
    return outputImage
  }
}





