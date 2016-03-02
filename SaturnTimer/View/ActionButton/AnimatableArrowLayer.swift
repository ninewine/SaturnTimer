//
//  AnimatableArrowLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/29/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableArrowLayer: AnimatableLayer {
  private let _arrowTop: CAShapeLayer = CAShapeLayer ()
  private let _arrowBottom: CAShapeLayer = CAShapeLayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _arrowTop.frame = frame
    _arrowTop.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    _arrowTop.position = CGPoint(x: 13.0, y: frame.height * 0.5)
    _arrowTop.path = _ActionButtonLayerPath.arrowTop.CGPath
    _arrowTop.lineCap = kCALineCapRound
    _arrowTop.strokeColor = HelperColor.lightGrayColor.CGColor
    _arrowTop.strokeStart = 0.5
    _arrowTop.strokeEnd = 0.5
    _arrowTop.colorType = ShapeLayerColorType.Stroke
    
    addSublayer(_arrowTop)
    
    _arrowBottom.frame = frame
    _arrowBottom.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    _arrowBottom.position = CGPoint(x: 13.0, y: frame.height * 0.5)
    _arrowBottom.path = _ActionButtonLayerPath.arrowBottom.CGPath
    _arrowBottom.lineCap = kCALineCapRound
    _arrowBottom.strokeColor = HelperColor.lightGrayColor.CGColor
    _arrowBottom.strokeStart = 0.5
    _arrowBottom.strokeEnd = 0.5
    _arrowBottom.colorType = ShapeLayerColorType.Stroke
    
    addSublayer(_arrowBottom)
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_arrowTop, _arrowBottom]
  }
  
  override func transitionIn(completion: (() -> ())?) {
    _arrowTop.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration * 0.3, type: .Start)
    _arrowBottom.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration * 0.3, type: .Start)
    _arrowTop.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration * 0.3, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._arrowTop.rotateAnimation(nil, to: CGFloat(-M_PI_4) * 0.9, duration: _self.transitionDuration * 0.3)
    }
    _arrowBottom.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration * 0.3, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._arrowBottom.rotateAnimation(nil, to: CGFloat(M_PI_4) * 0.9, duration: _self.transitionDuration * 0.3) { () -> Void in
        if let block = completion {
          block()
        }
      }
    }
  }
  
  
  override func transitionOut(completion: (() -> ())?) {
    _arrowTop.rotateAnimation(nil, to: 0.0, duration: transitionDuration * 0.3)
    _arrowBottom.rotateAnimation(nil, to: 0.0, duration: transitionDuration * 0.3) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._arrowTop.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .Start)
      _self._arrowBottom.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .Start)
      _self._arrowTop.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .End)
      _self._arrowBottom.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .End){ () -> Void in
        if let block = completion {
          block()
        }
      }
    }
    
  }
}
