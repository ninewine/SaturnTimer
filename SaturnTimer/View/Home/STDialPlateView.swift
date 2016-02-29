//
//  STDialPlateView.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import QorumLogs
import Result

class STDialPlateView: UIView {
  var _activeSlider: STDialPlateSliderView?

  var hourSlider : STDialPlateSliderView!
  var minuteSlider: STDialPlateSliderView!
  
  var playButton : STPlayButton!
  
  var touchEndSignal: Signal<Void, NoError>!
  
  private var touchEndObserver: Observer<Void, NoError>!
  
  private var _sliderEnabled = true
  
  private let _outerRing: CAShapeLayer = CAShapeLayer()
  private let _innerRing: CAShapeLayer = CAShapeLayer()
  
  private let _outerCyanRing: CAShapeLayer = CAShapeLayer()
  private let _outerCyanDot: CAShapeLayer = CAShapeLayer()
  private let _innerCyanRing: CAShapeLayer = CAShapeLayer()
  private let _innerCyanDot: CAShapeLayer = CAShapeLayer()
  
  private let _padding: CGFloat = 20.0
  private let _gapOfRings: CGFloat = 42.0
  private let _outerCyanDotDiameter: CGFloat = 10.0
  private let _innerCyanDotDiameter: CGFloat = 15.0
  
  private var _outerRingRadius: CGFloat = 0.0
  private var _innerRingRadius: CGFloat = 0.0
  
  private var _innerCenter: CGPoint = CGPointZero
  
  func configView () {
    clipsToBounds = false
    backgroundColor = UIColor.clearColor()
    
    //Touch End Signal and Observer
    let (touchEndSignal, touchEndObserver) = Signal<Void, NoError>.pipe()
    self.touchEndSignal = touchEndSignal
    self.touchEndObserver = touchEndObserver
    
    //Outer Ring

    _outerRing.strokeColor = HelperColor.lightGrayColor.CGColor
    _outerRing.fillColor = UIColor.clearColor().CGColor
    _outerRing.lineWidth = 2.0
    layer.addSublayer(_outerRing)
    
    //Inner Ring

    _innerRing.strokeColor = HelperColor.lightGrayColor.CGColor
    _innerRing.fillColor = UIColor.clearColor().CGColor
    _innerRing.lineWidth = 4.0
    layer.addSublayer(_innerRing)
    
    //Outer Cryan Ring
    
    _outerCyanRing.strokeColor = HelperColor.primaryColor.CGColor
    _outerCyanRing.fillColor = UIColor.clearColor().CGColor
    _outerCyanRing.lineWidth = 2.0
    _outerCyanRing.strokeEnd = 0.0
    layer.addSublayer(_outerCyanRing)
    _outerCyanRing.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
    
    //Outer Cryan Dot

    _outerCyanDot.strokeColor = UIColor.clearColor().CGColor
    _outerCyanDot.fillColor = HelperColor.primaryColor.CGColor
    layer.addSublayer(_outerCyanDot)
    
    //Inner Cryan Ring

    _innerCyanRing.strokeColor = HelperColor.primaryColor.CGColor
    _innerCyanRing.fillColor = UIColor.clearColor().CGColor
    _innerCyanRing.lineWidth = 4.0
    _innerCyanRing.strokeEnd = 0.0
    layer.addSublayer(_innerCyanRing)
    _innerCyanRing.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
    
    //Inner Cryan Dot
    
    _innerCyanDot.strokeColor = UIColor.clearColor().CGColor
    _innerCyanDot.fillColor = HelperColor.primaryColor.CGColor
    layer.addSublayer(_innerCyanDot)
    
    self.ringPathSetting()
    
    //Sliders
    
    minuteSlider = STDialPlateSliderView(image: UIImage(named: "pic-minute-planet")!)
    addSubview(minuteSlider)
    
    hourSlider = STDialPlateSliderView(image: UIImage(named: "pic-hour-planet")!)
    addSubview(hourSlider)
    
    resetSliderPosition()
    
    //Play Button
    
    playButton = STPlayButton(frame: CGRectZero)
    playButton.enabled = false
    addSubview(playButton)
    
    //Observe changes of bounds
    
    DynamicProperty(object: self, keyPath: "bounds").signal.observeNext {[weak self] (bounds) -> () in
      guard let _self = self else {return}
      _self.ringPathSetting()
      _self.resetSliderPosition()
      _self.resetPlayButtonFrame()
    }
    
    //Observe changes of Sliders
    minuteSlider
      .progress
      .producer
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .observeOn(QueueScheduler.mainQueueScheduler)
      .startWithNext {[weak self] (progress) -> () in
        guard let _self = self else {return}

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        _self._outerCyanRing.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
    
    hourSlider
      .progress
      .producer
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .observeOn(QueueScheduler.mainQueueScheduler)
      .startWithNext {[weak self] (progress) -> () in
        guard let _self = self else {return}
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        _self._innerCyanRing.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
  }
  
  func resetPlayButtonFrame () {
    let playButtonWidth: CGFloat = 90.0
    let playButtonHeight: CGFloat = 90.0
    
    let rect = CGRectMake(
      (bounds.width - playButtonWidth) * 0.5 ,
      (bounds.height - playButtonHeight) * 0.5 ,
      playButtonWidth,
      playButtonHeight
    )
    
    playButton.frame = rect
  }
  
  func ringPathSetting () {
    _outerRing.path = _DialPlateLayerPath.ringPath(CGRectInset(bounds, _padding, _padding)).CGPath
    _innerRing.path = _DialPlateLayerPath.ringPath(CGRectInset(bounds, _padding + _gapOfRings, _padding + _gapOfRings)).CGPath
    _outerCyanDot.path = _DialPlateLayerPath.ringPath(CGRectMake(0, 0, _outerCyanDotDiameter, _outerCyanDotDiameter)).CGPath
    _outerCyanDot.position = CGPoint(
      x: bounds.width * 0.5 - _outerCyanDotDiameter * 0.5,
      y: -(_outerCyanDotDiameter * 0.5) + _padding
    )
    _innerCyanDot.path = _DialPlateLayerPath.ringPath(CGRectMake(0, 0, _innerCyanDotDiameter, _innerCyanDotDiameter)).CGPath
    _innerCyanDot.position = CGPoint(
      x: bounds.width * 0.5 - _innerCyanDotDiameter * 0.5,
      y: -(_innerCyanDotDiameter * 0.5) + _padding + _gapOfRings
    )
    _outerCyanRing.frame = CGRectInset(bounds, _padding, _padding)
    _outerCyanRing.path = _DialPlateLayerPath.ringPath(_outerCyanRing.bounds).CGPath
    _innerCyanRing.frame = CGRectInset(bounds, _padding + _gapOfRings, _padding + _gapOfRings)
    _innerCyanRing.path = _DialPlateLayerPath.ringPath(_innerCyanRing.bounds).CGPath
  }
  
  //MARK: - Play Button
  
  func changePlayButtonAppearence (playing: Bool) {
    playButton.highlighting = playing
    playButton.changeButtonAppearance(playing)
  }

  
  //MARK: - Slider
  func resetSliderPosition () {
    _innerCenter = CGPointMake(bounds.width * 0.5, bounds.height * 0.5)
    _outerRingRadius = _innerCenter.y - _padding
    _innerRingRadius = _innerCenter.y - _padding - _gapOfRings
    
    let minuteSliderOrigin = CGPoint(
      x: bounds.width * 0.5 - minuteSlider.bounds.width * 0.5,
      y: -minuteSlider.bounds.height * 0.5 + _padding
    )
    let minuteSliderFrame = CGRect(
      x: minuteSliderOrigin.x,
      y: minuteSliderOrigin.y,
      width: minuteSlider.bounds.width,
      height: minuteSlider.bounds.height
    )
    minuteSlider.zeroPointCenter = CGPoint(
      x: minuteSliderOrigin.x + minuteSliderFrame.size.width * 0.5,
      y: minuteSliderOrigin.y + minuteSliderFrame.size.height * 0.5
    )
    minuteSlider.frame = minuteSliderFrame
    minuteSlider.ovalCenter = _innerCenter
    minuteSlider.ovalRadius = _outerRingRadius
    
    let hourSliderOrigin = CGPoint(
      x: bounds.width * 0.5 - hourSlider.bounds.width * 0.5,
      y: -(hourSlider.bounds.height * 0.5) + _padding + _gapOfRings
    )
    let hourSliderFrame = CGRect(
      x: hourSliderOrigin.x,
      y: hourSliderOrigin.y,
      width: hourSlider.bounds.width,
      height: hourSlider.bounds.height
    )
    hourSlider.zeroPointCenter = CGPoint(
      x: hourSliderOrigin.x + hourSliderFrame.size.width * 0.5,
      y: hourSliderOrigin.y + hourSliderFrame.size.height * 0.5
    )
    hourSlider.frame = hourSliderFrame
    hourSlider.ovalCenter = _innerCenter
    hourSlider.ovalRadius = _innerRingRadius
  }
  
  func enableSlider (enabled: Bool) {
    _sliderEnabled = enabled
  }
  
  func slideSlidersToProgress (progress: Double, duration: Double) {
    slideHourSliderToProgress(progress, duration: duration)
    slideMinuteSliderToProgress(progress, duration: duration)
  }
  
  func slideHourSliderToProgress (progress: Double,  duration: Double) {
    hourSlider.slideToProgress(progress, duration: duration)
    _innerCyanRing.pathStokeAnimationFrom(nil, to: CGFloat(progress), duration: duration, type: .End, timingFunctionName: kCAMediaTimingFunctionEaseInEaseOut)

  }
  
  func slideMinuteSliderToProgress (progress: Double,  duration: Double) {
    minuteSlider.slideToProgress(progress, duration: duration)
    _outerCyanRing.pathStokeAnimationFrom(nil, to: CGFloat(progress), duration: duration, type: .End, timingFunctionName: kCAMediaTimingFunctionEaseInEaseOut)
    
  }
  
  
  //MARK: - Touch
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if !_sliderEnabled {
      return
    }
    
    guard let point = touches.first?.locationInView(self) else {return}
    if CGRectContainsPoint(hourSlider.frame, point) {
      hourSlider.active = true
      _activeSlider = hourSlider
    }
    else if CGRectContainsPoint(minuteSlider.frame, point) {
      minuteSlider.active = true
      _activeSlider = minuteSlider
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if !_sliderEnabled {
      return
    }
    
    guard let point = touches.first?.locationInView(self), let slider = _activeSlider else {return}
    slider.slideWithRefrencePoint(point)
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    hourSlider.active = false
    minuteSlider.active = false
    _activeSlider = nil
    touchEndObserver.sendNext()
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    hourSlider.active = false
    minuteSlider.active = false
    _activeSlider = nil
    touchEndObserver.sendNext()
  }
  
  
}
