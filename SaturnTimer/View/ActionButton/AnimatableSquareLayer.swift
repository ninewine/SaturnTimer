//
//  AnimatableSquareLayer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class AnimatableSquareLayer: AnimatableLayer {
  fileprivate let _square: CAShapeLayer = CAShapeLayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(frame: CGRect) {
    super.init()
    _square.frame = frame
    _square.position = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    _square.path = _ActionButtonLayerPath.squarePath.cgPath
    _square.fillColor = HelperColor.lightGrayColor.cgColor
    _square.colorType = ShapeLayerColorType.fill
    addSublayer(_square)
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_square]
  }
}
