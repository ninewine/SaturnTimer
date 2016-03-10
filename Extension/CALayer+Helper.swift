//
//  CALayer+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop

enum ShapeLayerStrokeAnimationType {
	case Start, End
	
	var popPropertyName: String {
		switch self {
		case .Start: return kPOPShapeLayerStrokeStart
		case .End: return kPOPShapeLayerStrokeEnd
		}
	}

	var animationKey: String {
		switch self {
		case .Start: return "StrokeStartAnimation"
		case .End: return "StrokeEndAnimation"
		}
	}
}

extension CALayer {
	func st_applyAnimation(animation: CABasicAnimation) {
		let copy = animation.copy() as! CABasicAnimation
		
		if copy.fromValue != nil {
			if let pLayer = self.presentationLayer() as? CALayer {
				if let kp = copy.keyPath {
					copy.fromValue = pLayer.valueForKeyPath(kp)
				}
			}
		}
		if let kp = copy.keyPath {
			self.addAnimation(copy, forKey: kp)
			self.setValue(copy.toValue, forKeyPath:kp)
		}
	}
	
  func pathStokeAnimationFrom(from: CGFloat?, to: CGFloat, duration: CFTimeInterval, type: ShapeLayerStrokeAnimationType, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    applyPopAnimation(from, to: to, duration: duration, propertyName: type.popPropertyName, timingFunctionName: timingFunctionName, completion: completion)
  }
  
  func opacityAnimation(from: CGFloat?, to: CGFloat, duration: CFTimeInterval, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    applyPopAnimation(from, to: to, duration: duration, propertyName: kPOPLayerOpacity, timingFunctionName: timingFunctionName, completion: completion)
  }
  
  func rotateAnimation(from: CGFloat?, to: CGFloat, duration: CFTimeInterval, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    applyPopAnimation(from, to: to, duration: duration, propertyName: kPOPLayerRotation, timingFunctionName: timingFunctionName, completion: completion)
  }
  
  func applyPopAnimation (from: CGFloat?, to: CGFloat, duration: CFTimeInterval, propertyName: String, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    let anim = POPBasicAnimation(propertyNamed: propertyName)
    if from != nil {
      anim.fromValue = from!
    }
    anim.toValue = to
    anim.duration = duration
    anim.completionBlock = {anim in
      guard let block = completion else {
        return
      }
      block()
    }
    anim.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
    self.pop_addAnimation(anim, forKey: propertyName)
  }
	
	func setValueWithoutImplicitAnimation(value: AnyObject?, forKey key: String) {
		CATransaction.begin()
    CATransaction.setDisableActions(true)
		self.setValue(value, forKeyPath: key)
		CATransaction.commit()
	}
}
