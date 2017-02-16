//
//  ViewController.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/19/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit
import QorumLogs
import GPUImage

enum PlayButtonActionType: Int {
  case none, startTimer, pauseTimer
}

enum RigthBottomButtonActionType: Int {
  case none, stopTimer, menuAction
}

class STHomeViewController: STViewController {
  fileprivate var viewModel: STHomeViewModel!

  var dialPlateView: STDialPlateView!
  
  @IBOutlet weak var constraintWidthHourView: NSLayoutConstraint!
  @IBOutlet weak var constraintWidthSecondView: NSLayoutConstraint!
  @IBOutlet weak var constraintTopTagContentView: NSLayoutConstraint!
  
  @IBOutlet weak var tagContentView: UIView!
  @IBOutlet weak var hourItemView: UIView!
  @IBOutlet weak var secondItemView: UIView!
  
  @IBOutlet weak var hourLabel: UILabel!
  @IBOutlet weak var minuteLabel: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  
  @IBOutlet weak var actionButton: STActionButton!
  
  fileprivate var menuViewController: STMenuViewController!
  
  fileprivate var playButtonAction: CocoaAction<Any?>!
  fileprivate var actionButtonAction: CocoaAction<Any?>!
  
  fileprivate let cometManager = STCometManager()
  
  fileprivate var blurScreenshotImage: UIImage?
  fileprivate let blurScreenshotWorkerQueue: DispatchQueue = DispatchQueue(label: "SaturnTimer.BlurScreenshotWorkerQueue", attributes: [])
  
  let widthOfTimeItem: CGFloat = 60
  
  //MARK: - Lifecircle
  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    bindViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    HelperNotification.askForPermission()
    generateScreenshotWithBlurEffect()
  }
  
  func configView () {
    dialPlateView = STDialPlateView()
    view.insertSubview(dialPlateView, belowSubview: actionButton)
    
    dialPlateView.snp.makeConstraints { (make) -> Void in
      let leftRightMargin = HelperCommon.currentDeviceType == .iPad ? 180 : 15
      let topMargin =
      HelperCommon.currentDeviceType == .iPad
        ? 370
        : HelperCommon.currentDeviceType == .iPhone4 ? 180 : 220
      
      make.left.equalTo(leftRightMargin)
      make.right.equalTo(-leftRightMargin)
      make.top.equalTo(topMargin)
      make.width.equalTo(dialPlateView.snp.height).multipliedBy(1.0)
    }
    
    dialPlateView.configView()
    
    dialPlateView.hourSlider.progress
      .producer
      .observe(on: QueueScheduler.main)
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .startWithValues {[weak self] (progress) -> () in
        let hour: Int = Int(floor(12 * progress)) % 12
        self?.viewModel.hour.value = hour
    }
    
    dialPlateView.minuteSlider.progress
      .producer
      .observe(on: QueueScheduler.main)
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .startWithValues {[weak self] (progress) -> () in
        let minute: Int = Int(floor(60 * progress))
        self?.viewModel.minute.value = minute
    }
    
    dialPlateView.touchEndSignal
      .observe(on: UIScheduler())
      .observeValues({[weak self] (_) in
        guard let _self = self else {return}
        if _self.viewModel.hour.value == 0 {
          _self.dialPlateView.slideHourSliderToProgress(0.0, duration: 0.5)
        }
        if _self.viewModel.minute.value == 0 {
          _self.dialPlateView.slideMinuteSliderToProgress(0.0, duration: 0.5)
        }
        _self.generateScreenshotWithBlurEffect()
      })
    
    actionButton.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      switch button.type {
      case .menu:
        self?.openSettingsAction()
        break
      case .stop:
        self?.stopTimerAction()
        break
      case .close:
        self?.closeSettingsAction()
        break
      default:
        break
      }
    }
    
    configTagView()
    configComet()
    
    constraintWidthSecondView.constant = 0
    
    if HelperCommon.currentDeviceType == .iPhone4 {
      constraintTopTagContentView.constant = 30.0
    }
    else if HelperCommon.currentDeviceType == .iPad {
      constraintTopTagContentView.constant = 150.0
    }
    
    view.layoutIfNeeded()
  }
  
  func configTagView () {
    if let tagTypeName = UserDefaults.standard.string(forKey: HelperConstant.UserDefaultKey.CurrentTagTypeName) {
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
  
  func configComet () {
    cometManager.startWithContentView(self.view)
  }
  
  func bindViewModel () {
    viewModel = STHomeViewModel()
    
    viewModel.timeChangeSignal
      .observe(on: UIScheduler())
      .observeValues {[weak self] (time) -> () in
        self?.hourLabel.text = time.hour < 10 ? "0\(time.hour)" : "\(time.hour)"
        self?.minuteLabel.text = time.minute < 10 ? "0\(time.minute)" : "\(time.minute)"
        self?.secondLabel.text = time.second < 10 ? "0\(time.second)" : "\(time.second)"
    }
    
    viewModel.timeValidSignal
      .observe(on: UIScheduler())
      .combinePrevious(false)
      .observeValues { (oldValid, newValid) -> () in
        if newValid != oldValid {
          self.dialPlateView.playButton.enabled = newValid
        }
    }
    
    viewModel.timeTikTokSignal
      .observe(on: UIScheduler())
      .observeValues {[weak self] (time) -> () in
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
      .observe(on: UIScheduler())
      .startWithValues {[weak self] (playing) -> () in
        guard let _self = self else {return}
        UIView.beginAnimations("Time Item Animation", context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationCurve(.easeInOut)
        if playing {
          if _self.viewModel.hour.value == 0 {
            _self.constraintWidthHourView.constant = 0
            _self.hourItemView.alpha = 0.0
          }
          else {
            _self.constraintWidthHourView.constant = _self.widthOfTimeItem
            _self.hourItemView.alpha = 1.0
          }
          _self.constraintWidthSecondView.constant = _self.widthOfTimeItem
          _self.secondItemView.alpha = 1.0
        }
        else {
          _self.constraintWidthHourView.constant = _self.widthOfTimeItem
          _self.constraintWidthSecondView.constant = 0
          _self.hourItemView.alpha = 1.0
          _self.secondItemView.alpha = 0.0
        }
        _self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
        _self.dialPlateView.enableSlider(!playing)
        _self.dialPlateView.changePlayButtonAppearence(playing)
        
        _self.actionButton.type = playing ? .stop : .menu
        
        _self.generateScreenshotWithBlurEffect()
    }
    
    viewModel.tagType
      .signal
      .observe(on: UIScheduler())
      .combinePrevious(.SaturnType)
      .observeValues {[weak self] (oldType, newType) -> () in
        if newType != oldType {
          self?.configTagView()
        }
    }
    
    viewModel.actionButtonAction
      .events
      .observeValues { (event) -> () in
    }
    
    
    playButtonAction = CocoaAction(viewModel.playButtonAction, { _ in return () })
    actionButtonAction = CocoaAction(viewModel.actionButtonAction, {_ in return ()})

    dialPlateView.playButton.pressedSignal.observeValues {[weak self] (button) in
      self?.playButtonAction.execute(())
    }

  }
  
  //MARK: - Actions
  
  func stopTimerAction() {
    if viewModel.playing.value {      //Stop the timer
      dialPlateView.playButton.highlighting = false
      dialPlateView.slideSlidersToProgress(0.0, duration: 1.0)
    }
    actionButtonAction.execute(())
  }
  
  func openSettingsAction () {
    actionButton.type = .close
    
    if menuViewController == nil {
      if let viewController = self.storyboard?.instantiateViewController(withIdentifier: STMenuViewController.classString()) as? STMenuViewController {
        if let image = blurScreenshotImage {
          viewController.view.layer.contents = image.cgImage
        }
        viewController.bindViewModelToHomeViewModel(viewModel)
        viewController.actionButton = self.actionButton
        viewController.view.alpha = 0.0
        viewController.willMove(toParentViewController: self)
        view.insertSubview(viewController.view, belowSubview: actionButton)
        viewController.didMove(toParentViewController: self)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
          viewController.view.alpha = 1.0
          }, completion: {(flag) -> Void in
            viewController.didMove(toParentViewController: self)
        }) 
        menuViewController = viewController

      }
    }
  }
  
  func closeSettingsAction () {
    if actionButton.type == .back {
      //Close Change Sounds View, proceeding in STMenuViewController
      return
    }
    
    actionButton.type = .menu

    if menuViewController != nil {
      menuViewController.willMove(toParentViewController: nil)
      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        self.menuViewController.view.alpha = 0.0
        }, completion: { (flag) -> Void in
          self.menuViewController.view.removeFromSuperview()
          self.menuViewController.didMove(toParentViewController: nil)
          self.menuViewController = nil
      })
    }
  }
  
  
  
  func generateScreenshotWithBlurEffect () {
    blurScreenshotWorkerQueue.async {[weak self] () -> Void in
      let screenBounds = UIScreen.main.bounds
      let screenScale = UIScreen.main.scale
      
      UIGraphicsBeginImageContextWithOptions(screenBounds.size, true, screenScale)
      var screenshot: UIImage?
      if let context = UIGraphicsGetCurrentContext() {
        self?.view.window?.layer.render(in: context)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()
      }
      UIGraphicsEndImageContext()
      
      //resize
      let size = CGSize(width: screenBounds.width / screenScale, height: screenBounds.height / screenScale)
      UIGraphicsBeginImageContext(size)
      screenshot?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      let blurImageSource = GPUImagePicture(image: image)
      
      let blurImageFillter = GPUImageGaussianBlurFilter()
      blurImageFillter.forceProcessing(at: screenBounds.size)
      blurImageFillter.blurRadiusInPixels = 12
      blurImageSource?.addTarget(blurImageFillter)
      blurImageFillter.useNextFrameForImageCapture()
      blurImageSource?.processImage()
      
      let outputImage = blurImageFillter.imageFromCurrentFramebuffer()
            
      self?.blurScreenshotImage = outputImage
    }
    
  }
}





