//
//  AnimatableGearLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableGearLayer: AnimatableLayer {
  fileprivate let _gear: CAShapeLayer = CAShapeLayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _gear.frame = frame
    _gear.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    _gear.path = _ActionButtonLayerPath.gearPath.cgPath
    _gear.strokeColor = HelperColor.lightGrayColor.cgColor
    _gear.fillColor = UIColor.clear.cgColor
    _gear.colorType = ShapeLayerColorType.stroke
    _gear.strokeEnd = 0.0
    addSublayer(_gear)
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_gear]
  }
  
  override func transitionIn(_ completion: (() -> ())?) {
    _gear.pathStokeAnimationFrom(nil, to: 1.0, duration: transitionDuration, type: .end) { () -> Void in
      if let block = completion {
        block()
      }
    }
  }
  
  
  override func transitionOut(_ completion: (() -> ())?) {
    _gear.pathStokeAnimationFrom(nil, to: 0.0, duration: transitionDuration, type: .end) { () -> Void in
      if let block = completion {
        block ()
      }
    }
  }
}
