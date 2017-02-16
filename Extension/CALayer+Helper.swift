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
	case start, end
	
	var popPropertyName: String {
		switch self {
		case .start: return kPOPShapeLayerStrokeStart
		case .end: return kPOPShapeLayerStrokeEnd
		}
	}

	var animationKey: String {
		switch self {
		case .start: return "StrokeStartAnimation"
		case .end: return "StrokeEndAnimation"
		}
	}
}

extension CALayer {
	func st_applyAnimation(_ animation: CABasicAnimation) {
		let copy = animation.copy() as! CABasicAnimation
		
		if copy.fromValue != nil {
			if let pLayer = self.presentation(){
				if let kp = copy.keyPath {
					copy.fromValue = pLayer.value(forKeyPath: kp)
				}
			}
		}
		if let kp = copy.keyPath {
			self.add(copy, forKey: kp)
			self.setValue(copy.toValue, forKeyPath:kp)
		}
	}
	
  func pathStokeAnimationFrom(_ from: CGFloat?, to: CGFloat, duration: CFTimeInterval, type: ShapeLayerStrokeAnimationType, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    applyPopAnimation(from, to: to, duration: duration, propertyName: type.popPropertyName, timingFunctionName: timingFunctionName, completion: completion)
  }
  
  func opacityAnimation(_ from: CGFloat?, to: CGFloat, duration: CFTimeInterval, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    applyPopAnimation(from, to: to, duration: duration, propertyName: kPOPLayerOpacity, timingFunctionName: timingFunctionName, completion: completion)
  }
  
  func rotateAnimation(_ from: CGFloat?, to: CGFloat, duration: CFTimeInterval, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    applyPopAnimation(from, to: to, duration: duration, propertyName: kPOPLayerRotation, timingFunctionName: timingFunctionName, completion: completion)
  }
  
  func applyPopAnimation (_ from: CGFloat?, to: CGFloat, duration: CFTimeInterval, propertyName: String, timingFunctionName: String = kCAMediaTimingFunctionDefault, completion: (()->Void)? = nil) {
    let anim = POPBasicAnimation(propertyNamed: propertyName)
    if from != nil {
      anim?.fromValue = from!
    }
    anim?.toValue = to
    anim?.duration = duration
    anim?.completionBlock = {anim in
      guard let block = completion else {
        return
      }
      block()
    }
    anim?.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
    self.pop_add(anim, forKey: propertyName)
  }
	
	func setValueWithoutImplicitAnimation(_ value: Any?, forKey key: String) {
		CATransaction.begin()
    CATransaction.setDisableActions(true)
		self.setValue(value, forKeyPath: key)
		CATransaction.commit()
	}
}
