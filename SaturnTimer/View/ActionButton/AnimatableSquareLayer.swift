//
//  AnimatableSquareLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableSquareLayer: AnimatableLayer {
  private let _square: CAShapeLayer = CAShapeLayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _square.frame = frame
    _square.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    _square.path = _ActionButtonLayerPath.squarePath.CGPath
    _square.fillColor = HelperColor.lightGrayColor.CGColor
    _square.colorType = ShapeLayerColorType.Fill
    addSublayer(_square)
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_square]
  }
}
