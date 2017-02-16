//
//  Television.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/18/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop

class Television: AnimatableTag {
  
	fileprivate let _body: CAShapeLayer = CAShapeLayer()
	fileprivate let _st_screen: CAShapeLayer = CAShapeLayer()
	fileprivate let _antenna1: CAShapeLayer = CAShapeLayer()
	fileprivate let _antenna2: CAShapeLayer = CAShapeLayer()
	fileprivate let _switch: CAShapeLayer = CAShapeLayer()
	fileprivate let _speaker1: CAShapeLayer = CAShapeLayer()
	fileprivate let _speaker2: CAShapeLayer = CAShapeLayer()
	
	fileprivate var _snowAry: [CALayer]!
	
	fileprivate let _duration: CFTimeInterval = 1.0
	
	override func viewConfig() {
    _fixedSize = CGSize(width: 23, height: 24)
    
		super.viewConfig()
		
		_body.path = _TelevisionLayerPath.bodyPath.cgPath
		_st_screen.path =  _TelevisionLayerPath.screenPath.cgPath
		_antenna1.path = _TelevisionLayerPath.antennaPath1.cgPath
		_antenna2.path = _TelevisionLayerPath.antennaPath2.cgPath
		_switch.path = _TelevisionLayerPath.switchPath.cgPath
		_speaker1.path = _TelevisionLayerPath.speakerPath1.cgPath
		_speaker2.path = _TelevisionLayerPath.speakerPath2.cgPath
		
		let layersStroke = [_body, _st_screen, _antenna1, _antenna2, _switch, _speaker1, _speaker2]
		for layer in layersStroke {
			layer.isOpaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.strokeStart = 0.0
			layer.strokeEnd = 0.0
			layer.strokeColor = currentAppearenceColor()
			layer.fillColor = UIColor.clear.cgColor
			_contentView.layer.addSublayer(layer)
		}
		
		_antenna1.frame = CGRect(x: 6, y: 3.28, width: 12, height: 6.56)
		_antenna2.frame = CGRect(x: 6, y: 3.28, width: 12, height: 6.56)
		_antenna1.anchorPoint = CGPoint(x: 1.0, y: 1.0)
		_antenna2.anchorPoint = CGPoint(x: 0.0, y: 1.0)

		//Snow
		_snowAry = (0..<9).flatMap({ (index) -> CALayer? in
      let snow = CALayer()
      snow.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
      let row: Int = index / 3
      let col: Int = index % 3
      let gap: Int = 2
      snow.opacity = 0.0
      snow.position = CGPoint(x: CGFloat(row * gap) + 7.3, y: CGFloat(col * gap) + 13.1)
      snow.backgroundColor = HelperColor.lightGrayColor.cgColor
      _contentView.layer.addSublayer(snow)
      return snow
    })
		_snowAry = _snowAry.shuffled()

		enterAnimation()
	}
	
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_body, _st_screen, _antenna1, _antenna2, _switch, _speaker1, _speaker2]
  }
	
	override func startAnimation() {
		_pausing = false
		televisionAnimation()
		snowAnimation()
	}
	
	override func stopAnimation() {
		_pausing = true
		
		_antenna1.transform = CATransform3DIdentity
		_antenna2.transform = CATransform3DIdentity

		for snow in _snowAry {
			snow.pop_removeAllAnimations()
			snow.opacity = 0.0
		}
	}
	
	
	// Enter Animation
	
	func enterAnimation () {
		_body.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .end) {[weak self] () -> Void in
      guard let _self = self else {return}
      
			_self._st_screen.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end, completion: {[weak self] () -> Void in
        guard let _self = self else {return}
				
				_self._switch.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end, completion: {[weak self] () -> Void in
          guard let _self = self else {return}

					_self._speaker1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end)
					_self._speaker2.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end, completion: {[weak self] () -> Void in
            guard let _self = self else {return}
						
						_self._antenna1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end)
						_self._antenna2.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end, completion: {[weak self] () -> Void in
              guard let _self = self else {return}

							_self.televisionAnimation()
							_self.snowAnimation()
						})
					})
				})
			})
		}
	}
	
	//Television Animation
	
	func televisionAnimation () {
		if _pausing {
			return
		}

		let rotationAnimFrom1 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		rotationAnimFrom1?.toValue = -M_PI_2 * 0.2
		rotationAnimFrom1?.completionBlock = {[weak self] anim in
      guard let _self = self else {return}

			let rotationAnimTo1 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
			rotationAnimTo1?.toValue = 0
			_self._antenna1.pop_add(rotationAnimTo1, forKey: "RotationAnimTo")
		}
		_antenna1.pop_add(rotationAnimFrom1, forKey: "RotationAnimFrom")
		
		let rotationAnimFrom2 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		rotationAnimFrom2?.toValue = M_PI_2 * 0.2
		rotationAnimFrom2?.completionBlock = {[weak self] anim in
      guard let _self = self else {return}

			let rotationAnimTo2 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
			rotationAnimTo2?.toValue = 0
			rotationAnimTo2?.completionBlock = { anim in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {[weak self] in
          self?.televisionAnimation()
        })
			}
			_self._antenna2.pop_add(rotationAnimTo2, forKey: "RotationAnimTo")
		}
		_antenna2.pop_add(rotationAnimFrom2, forKey: "RotationAnimFrom")
	}
	
	//Snow Animation
	
	func snowAnimation () {
		for (index, snow) in  _snowAry.enumerated() {
			let opacityAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
			opacityAnim?.toValue = 1.0
			opacityAnim?.repeatForever = true
			opacityAnim?.autoreverses = true
			opacityAnim?.duration = 0.6
			opacityAnim?.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * 0.7
			snow.pop_add(opacityAnim, forKey: "OpacityAnimation")
		}
	}
}
















