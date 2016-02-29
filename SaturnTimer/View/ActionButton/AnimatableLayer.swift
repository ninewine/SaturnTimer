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
  
  func setHighlightStatus(highlighted: Bool, animated: Bool) {
    guard let layers = layersNeedToBeHighlighted() else {return}
    
    let _ = layers.flatMap { (layer) -> CAShapeLayer in
      layer.pop_removeAllAnimations()
      if animated {
        let propertyName = layer.colorType == .Fill ? kPOPShapeLayerFillColor : kPOPShapeLayerStrokeColor
        let colorAnimation = POPBasicAnimation(propertyNamed: propertyName)
        colorAnimation.duration = 0.2
        colorAnimation.toValue = highlighted ? HelperColor.primaryColor.CGColor : HelperColor.lightGrayColor.CGColor
        layer.pop_addAnimation(colorAnimation, forKey: "ColorAnimation")
      }
      else {
        if layer.colorType == .Fill {
          layer.fillColor = highlighted ? HelperColor.primaryColor.CGColor : HelperColor.lightGrayColor.CGColor
        }
        else {
          layer.strokeColor = highlighted ? HelperColor.primaryColor.CGColor : HelperColor.lightGrayColor.CGColor
        }
      }
      return layer
    }
  }
  
  func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return nil
  }

  func transitionIn (completion: (()->())?) {
    if let block = completion {
      block()
    }
  }
  
  func transitionOut (completion: (()->())?) {
    if let block = completion {
      block()
    }
  }
  
}
