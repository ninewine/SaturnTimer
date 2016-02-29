//
//  AnimatableRingLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableRingLayer: AnimatableLayer {
  private let _ring: CAShapeLayer = CAShapeLayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _ring.frame = frame
    _ring.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    _ring.path = _ActionButtonLayerPath.ringPath.CGPath
    _ring.strokeColor = HelperColor.lightGrayColor.CGColor
    _ring.fillColor = UIColor.clearColor().CGColor
    _ring.strokeEnd = 0.0
    _ring.colorType = ShapeLayerColorType.Stroke
    addSublayer(_ring)
  }

  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_ring]
  }
  
  override func transitionIn(completion: (() -> ())?) {
    _ring.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration, type: .End) { () -> Void in
      if let block = completion {
        block ()
      }
    }
  }

}
