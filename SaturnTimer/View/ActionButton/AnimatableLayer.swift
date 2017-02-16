//
//  STAnimatableLayerProtocol.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop

class AnimatableLayer : CALayer, HighlightableProtocol {
  
  var transitionDuration: Double = 0.5
  
  func setHighlightStatus(_ highlighted: Bool, animated: Bool) {
    guard let layers = layersNeedToBeHighlighted() else {return}
    
    let _ = layers.flatMap { (layer) -> CAShapeLayer in
      layer.pop_removeAllAnimations()
      if animated {
        let type: ShapeLayerColorType = layer.colorType ?? .fill
        let propertyName = type == .fill ? kPOPShapeLayerFillColor : kPOPShapeLayerStrokeColor
        let colorAnimation = POPBasicAnimation(propertyNamed: propertyName)
        colorAnimation?.duration = 0.2
        colorAnimation?.toValue = highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
        layer.pop_add(colorAnimation, forKey: "ColorAnimation")
      }
      else {
        if layer.colorType == .fill {
          layer.fillColor = highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
        }
        else {
          layer.strokeColor = highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
        }
      }
      return layer
    }
  }
  
  func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return nil
  }

  func transitionIn (_ completion: (()->())?) {
    if let block = completion {
      block()
    }
  }
  
  func transitionOut (_ completion: (()->())?) {
    if let block = completion {
      block()
    }
  }
  
}
