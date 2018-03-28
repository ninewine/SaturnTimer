//
//  AnimatableArrowLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/29/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableArrowLayer: AnimatableLayer {
  fileprivate let _arrowTop: CAShapeLayer = CAShapeLayer ()
  fileprivate let _arrowBottom: CAShapeLayer = CAShapeLayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _arrowTop.frame = frame
    _arrowTop.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    _arrowTop.position = CGPoint(x: 13.0, y: frame.height * 0.5)
    _arrowTop.path = _ActionButtonLayerPath.arrowTop.cgPath
    _arrowTop.lineCap = kCALineCapRound
    _arrowTop.strokeColor = HelperColor.lightGrayColor.cgColor
    _arrowTop.strokeStart = 0.5
    _arrowTop.strokeEnd = 0.5
    _arrowTop.colorType = ShapeLayerColorType.stroke
    
    addSublayer(_arrowTop)
    
    _arrowBottom.frame = frame
    _arrowBottom.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    _arrowBottom.position = CGPoint(x: 13.0, y: frame.height * 0.5)
    _arrowBottom.path = _ActionButtonLayerPath.arrowBottom.cgPath
    _arrowBottom.lineCap = kCALineCapRound
    _arrowBottom.strokeColor = HelperColor.lightGrayColor.cgColor
    _arrowBottom.strokeStart = 0.5
    _arrowBottom.strokeEnd = 0.5
    _arrowBottom.colorType = ShapeLayerColorType.stroke
    
    addSublayer(_arrowBottom)
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_arrowTop, _arrowBottom]
  }
  
  override func transitionIn(_ completion: (() -> ())?) {
    _arrowTop.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration * 0.3, type: .start)
    _arrowBottom.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration * 0.3, type: .start)
    _arrowTop.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration * 0.3, type: .end) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._arrowTop.rotateAnimation(nil, to: -CGFloat.pi * 0.25 * 0.9, duration: _self.transitionDuration * 0.3)
    }
    _arrowBottom.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration * 0.3, type: .end) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._arrowBottom.rotateAnimation(nil, to: -CGFloat.pi * 0.25 * 0.9, duration: _self.transitionDuration * 0.3) { () -> Void in
        if let block = completion {
          block()
        }
      }
    }
  }
  
  
  override func transitionOut(_ completion: (() -> ())?) {
    _arrowTop.rotateAnimation(nil, to: 0.0, duration: transitionDuration * 0.3)
    _arrowBottom.rotateAnimation(nil, to: 0.0, duration: transitionDuration * 0.3) {[weak self] () -> Void in
      guard let _self = self else {return}
      _self._arrowTop.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .start)
      _self._arrowBottom.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .start)
      _self._arrowTop.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .end)
      _self._arrowBottom.pathStokeAnimationFrom(nil, to: 0.5, duration: _self.transitionDuration * 0.3, type: .end){ () -> Void in
        if let block = completion {
          block()
        }
      }
    }
    
  }
}
