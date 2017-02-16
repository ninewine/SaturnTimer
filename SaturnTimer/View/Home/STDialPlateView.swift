//
//  STDialPlateView.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import QorumLogs
import Result

class STDialPlateView: UIView {
  var _activeSlider: STDialPlateSliderView?

  var hourSlider : STDialPlateSliderView!
  var minuteSlider: STDialPlateSliderView!
  
  var playButton : STPlayButton!
  
  var touchEndSignal: Signal<Any?, NoError>!
  
  fileprivate var touchEndObserver: Observer<Any?, NoError>!
  
  fileprivate var _sliderEnabled = true
  
  fileprivate let _outerRing: CAShapeLayer = CAShapeLayer()
  fileprivate let _innerRing: CAShapeLayer = CAShapeLayer()
  
  fileprivate let _outerCyanRing: CAShapeLayer = CAShapeLayer()
  fileprivate let _outerCyanDot: CAShapeLayer = CAShapeLayer()
  fileprivate let _innerCyanRing: CAShapeLayer = CAShapeLayer()
  fileprivate let _innerCyanDot: CAShapeLayer = CAShapeLayer()
  
  fileprivate let _padding: CGFloat = 20.0
  fileprivate let _gapOfRings: CGFloat = 42.0
  fileprivate let _outerCyanDotDiameter: CGFloat = 10.0
  fileprivate let _innerCyanDotDiameter: CGFloat = 15.0
  
  fileprivate var _outerRingRadius: CGFloat = 0.0
  fileprivate var _innerRingRadius: CGFloat = 0.0
  
  fileprivate var _innerCenter: CGPoint = CGPoint.zero
  
  func configView () {
    clipsToBounds = false
    backgroundColor = UIColor.clear
    
    //Touch End Signal and Observer
    let (touchEndSignal, touchEndObserver) = Signal<Any?, NoError>.pipe()
    self.touchEndSignal = touchEndSignal
    self.touchEndObserver = touchEndObserver
    
    //Outer Ring

    _outerRing.strokeColor = HelperColor.lightGrayColor.cgColor
    _outerRing.fillColor = UIColor.clear.cgColor
    _outerRing.lineWidth = 2.0
    layer.addSublayer(_outerRing)
    
    //Inner Ring

    _innerRing.strokeColor = HelperColor.lightGrayColor.cgColor
    _innerRing.fillColor = UIColor.clear.cgColor
    _innerRing.lineWidth = 4.0
    layer.addSublayer(_innerRing)
    
    //Outer Cryan Ring
    
    _outerCyanRing.strokeColor = HelperColor.primaryColor.cgColor
    _outerCyanRing.fillColor = UIColor.clear.cgColor
    _outerCyanRing.lineWidth = 2.0
    _outerCyanRing.strokeEnd = 0.0
    layer.addSublayer(_outerCyanRing)
    _outerCyanRing.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
    
    //Outer Cryan Dot

    _outerCyanDot.strokeColor = UIColor.clear.cgColor
    _outerCyanDot.fillColor = HelperColor.primaryColor.cgColor
    layer.addSublayer(_outerCyanDot)
    
    //Inner Cryan Ring

    _innerCyanRing.strokeColor = HelperColor.primaryColor.cgColor
    _innerCyanRing.fillColor = UIColor.clear.cgColor
    _innerCyanRing.lineWidth = 4.0
    _innerCyanRing.strokeEnd = 0.0
    layer.addSublayer(_innerCyanRing)
    _innerCyanRing.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 0.0, 1.0)
    
    //Inner Cryan Dot
    
    _innerCyanDot.strokeColor = UIColor.clear.cgColor
    _innerCyanDot.fillColor = HelperColor.primaryColor.cgColor
    layer.addSublayer(_innerCyanDot)
    
    self.ringPathSetting()
    
    //Sliders
    
    minuteSlider = STDialPlateSliderView(image: UIImage(named: "pic-minute-planet")!)
    addSubview(minuteSlider)
    
    hourSlider = STDialPlateSliderView(image: UIImage(named: "pic-hour-planet")!)
    addSubview(hourSlider)
    
    resetSliderPosition()
    
    //Play Button
    
    playButton = STPlayButton(frame: CGRect.zero)
    playButton.enabled = false
    addSubview(playButton)
    
    //Observe changes of bounds
    reactive.values(forKeyPath: "bounds").startWithValues {[weak self] (rect) in
      self?.ringPathSetting()
      self?.resetSliderPosition()
      self?.resetPlayButtonFrame()
    }
    
    //Observe changes of Sliders
    minuteSlider
      .progress
      .producer
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .observe(on: UIScheduler())
      .startWithValues {[weak self] (progress) -> () in
        guard let _self = self else {return}

        _self._outerCyanRing.setValueWithoutImplicitAnimation(CGFloat(progress), forKey: "strokeEnd")

    }
    
    hourSlider
      .progress
      .producer
      .filter { (progress) -> Bool in
        return progress >= 0.0 && progress <= 1.0
      }
      .observe(on: UIScheduler())
      .startWithValues {[weak self] (progress) -> () in
        guard let _self = self else {return}
        
        _self._innerCyanRing.setValueWithoutImplicitAnimation(CGFloat(progress), forKey: "strokeEnd")
    }
  }
  
  func resetPlayButtonFrame () {
    let playButtonWidth: CGFloat = 90.0
    let playButtonHeight: CGFloat = 90.0
    
    let rect = CGRect(
      x: (bounds.width - playButtonWidth) * 0.5 ,
      y: (bounds.height - playButtonHeight) * 0.5 ,
      width: playButtonWidth,
      height: playButtonHeight
    )
    
    playButton.frame = rect
  }
  
  func ringPathSetting () {
    _outerRing.path = _DialPlateLayerPath.ringPath(bounds.insetBy(dx: _padding, dy: _padding)).cgPath
    _innerRing.path = _DialPlateLayerPath.ringPath(bounds.insetBy(dx: _padding + _gapOfRings, dy: _padding + _gapOfRings)).cgPath
    _outerCyanDot.path = _DialPlateLayerPath.ringPath(CGRect(x: 0, y: 0, width: _outerCyanDotDiameter, height: _outerCyanDotDiameter)).cgPath
    _outerCyanDot.position = CGPoint(
      x: bounds.width * 0.5 - _outerCyanDotDiameter * 0.5,
      y: -(_outerCyanDotDiameter * 0.5) + _padding
    )
    _innerCyanDot.path = _DialPlateLayerPath.ringPath(CGRect(x: 0, y: 0, width: _innerCyanDotDiameter, height: _innerCyanDotDiameter)).cgPath
    _innerCyanDot.position = CGPoint(
      x: bounds.width * 0.5 - _innerCyanDotDiameter * 0.5,
      y: -(_innerCyanDotDiameter * 0.5) + _padding + _gapOfRings
    )
    _outerCyanRing.frame = bounds.insetBy(dx: _padding, dy: _padding)
    _outerCyanRing.path = _DialPlateLayerPath.ringPath(_outerCyanRing.bounds).cgPath
    _innerCyanRing.frame = bounds.insetBy(dx: _padding + _gapOfRings, dy: _padding + _gapOfRings)
    _innerCyanRing.path = _DialPlateLayerPath.ringPath(_innerCyanRing.bounds).cgPath
  }
  
  //MARK: - Play Button
  
  func changePlayButtonAppearence (_ playing: Bool) {
    playButton.highlighting = playing
    playButton.changeButtonAppearance(playing)
  }

  
  //MARK: - Slider
  func resetSliderPosition () {
    _innerCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
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
  
  func enableSlider (_ enabled: Bool) {
    _sliderEnabled = enabled
    minuteSlider.enabled = enabled
    hourSlider.enabled = enabled
  }
  
  func slideSlidersToProgress (_ progress: Double, duration: Double) {
    slideHourSliderToProgress(progress, duration: duration)
    slideMinuteSliderToProgress(progress, duration: duration)
  }
  
  func slideHourSliderToProgress (_ progress: Double,  duration: Double) {
    hourSlider.slideToProgress(progress, duration: duration)
    _innerCyanRing.pathStokeAnimationFrom(nil, to: CGFloat(progress), duration: duration, type: .end, timingFunctionName: kCAMediaTimingFunctionEaseInEaseOut)

  }
  
  func slideMinuteSliderToProgress (_ progress: Double,  duration: Double) {
    minuteSlider.slideToProgress(progress, duration: duration)
    _outerCyanRing.pathStokeAnimationFrom(nil, to: CGFloat(progress), duration: duration, type: .end, timingFunctionName: kCAMediaTimingFunctionEaseInEaseOut)
    
  }
  
  
  //MARK: - Touch
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !_sliderEnabled {
      return
    }
    
    guard let point = touches.first?.location(in: self) else {return}
    if hourSlider.frame.contains(point) {
      hourSlider.active = true
      _activeSlider = hourSlider
    }
    else if minuteSlider.frame.contains(point) {
      minuteSlider.active = true
      _activeSlider = minuteSlider
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !_sliderEnabled {
      return
    }
    
    guard let point = touches.first?.location(in: self), let slider = _activeSlider else {return}
    slider.slideWithRefrencePoint(point)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let point = touches.first?.location(in: self), let slider = _activeSlider {
      slider.slideWithRefrencePoint(point)
    }
    
    hourSlider.active = false
    minuteSlider.active = false
    _activeSlider = nil
    touchEndObserver.send(value: nil)

  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let point = touches.first?.location(in: self), let slider = _activeSlider {
      slider.slideWithRefrencePoint(point)
    }
    
    hourSlider.active = false
    minuteSlider.active = false
    _activeSlider = nil
    touchEndObserver.send(value: nil)
  }
  
  
}
