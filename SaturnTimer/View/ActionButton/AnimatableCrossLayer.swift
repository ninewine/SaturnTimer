//
//  AnimatableCrossLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableCrossLayer: AnimatableLayer {
  private let _cross1: CAShapeLayer = CAShapeLayer ()
  private let _cross2: CAShapeLayer = CAShapeLayer ()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _cross1.frame = frame
    _cross1.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    _cross1.path = _ActionButtonLayerPath.crossPath.CGPath
    _cross1.lineCap = kCALineCapRound
    _cross1.strokeColor = HelperColor.lightGrayColor.CGColor
    _cross1.strokeStart = 0.5
    _cross1.strokeEnd = 0.5
    _cross1.colorType = ShapeLayerColorType.Stroke

    addSublayer(_cross1)
    
    _cross2.frame = frame
    _cross2.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    _cross2.path = _ActionButtonLayerPath.crossPath.CGPath
    _cross2.lineCap = kCALineCapRound
    _cross2.strokeColor = HelperColor.lightGrayColor.CGColor
    _cross2.strokeStart = 0.5
    _cross2.strokeEnd = 0.5
    _cross2.colorType = ShapeLayerColorType.Stroke

    addSublayer(_cross2)
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_cross1, _cross2]
  }
  
  override func transitionIn(completion: (() -> ())?) {
    _cross1.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration * 0.5, type: .Start)
    _cross2.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration * 0.5, type: .Start)
    _cross1.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration * 0.5, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._cross1.rotateAnimation(nil, to: CGFloat(-M_PI_4), duration: _self.transitionDuration * 0.5)
    }
    _cross2.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration * 0.5, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._cross2.rotateAnimation(nil, to: CGFloat(M_PI_4), duration: _self.transitionDuration * 0.5) { () -> Void in
        if let block = completion {
          block()
        }
      }
    }
  }
  
  
  override func transitionOut(completion: (() -> ())?) {
    _cross1.rotateAnimation(nil, to: 0.0, duration: transitionDuration * 0.5)
    _cross2.rotateAnimation(nil, to: 0.0, duration: transitionDuration * 0.5) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._cross1.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.5, type: .Start)
      _self._cross2.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.5, type: .Start)
      _self._cross1.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.5, type: .End)
      _self._cross2.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.5, type: .End){ () -> Void in
        if let block = completion {
          block()
        }
      }
    }

  }
}
