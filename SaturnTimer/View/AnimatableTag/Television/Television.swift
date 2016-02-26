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
	private let _fixedSize: CGSize = CGSizeMake(23, 24)
	
	private let _body: CAShapeLayer = CAShapeLayer()
	private let _st_screen: CAShapeLayer = CAShapeLayer()
	private let _antenna1: CAShapeLayer = CAShapeLayer()
	private let _antenna2: CAShapeLayer = CAShapeLayer()
	private let _switch: CAShapeLayer = CAShapeLayer()
	private let _speaker1: CAShapeLayer = CAShapeLayer()
	private let _speaker2: CAShapeLayer = CAShapeLayer()
	
	private var _snowAry: [CALayer]!
	
	private let _duration: CFTimeInterval = 1.0
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, _fixedSize.width, _fixedSize.height))
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		frame.size.width = _fixedSize.width
		frame.size.height = _fixedSize.height
	}
	
	override func viewConfig() {
		super.viewConfig()
		backgroundColor = UIColor.clearColor()
		
		_body.path = _TelevisionLayerPath.bodyPath.CGPath
		_st_screen.path =  _TelevisionLayerPath.screenPath.CGPath
		_antenna1.path = _TelevisionLayerPath.antennaPath1.CGPath
		_antenna2.path = _TelevisionLayerPath.antennaPath2.CGPath
		_switch.path = _TelevisionLayerPath.switchPath.CGPath
		_speaker1.path = _TelevisionLayerPath.speakerPath1.CGPath
		_speaker2.path = _TelevisionLayerPath.speakerPath2.CGPath
		
		let layersStroke = [_body, _st_screen, _antenna1, _antenna2, _switch, _speaker1, _speaker2]
		for layer in layersStroke {
			layer.opaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.strokeStart = 0.0
			layer.strokeEnd = 0.0
			layer.strokeColor = HelperColor.primaryColor.CGColor
			layer.fillColor = UIColor.clearColor().CGColor
			self.layer.addSublayer(layer)
		}
		
		_antenna1.frame = CGRect(x: 6, y: 3.28, width: 12, height: 6.56)
		_antenna2.frame = CGRect(x: 6, y: 3.28, width: 12, height: 6.56)
		_antenna1.anchorPoint = CGPoint(x: 1.0, y: 1.0)
		_antenna2.anchorPoint = CGPoint(x: 0.0, y: 1.0)

		//Snow
		
		_snowAry = (0..<9).flatMap({ (index) -> CALayer in
			let snow = CALayer()
			snow.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
			let row: Int = index / 3
			let col: Int = index % 3
			let gap: Int = 2
			snow.opacity = 0.0
			snow.position = CGPointMake(CGFloat(row * gap) + 7.3, CGFloat(col * gap) + 13.1)
			snow.backgroundColor = HelperColor.primaryColor.CGColor
			layer.addSublayer(snow)
			return snow
		}).shuffle()

		enterAnimation()
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
		_body.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}
      
			_self._st_screen.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End, completion: {[weak self] () -> Void in
        guard let _self = self else {return}
				
				_self._switch.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End, completion: {[weak self] () -> Void in
          guard let _self = self else {return}

					_self._speaker1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End)
					_self._speaker2.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End, completion: {[weak self] () -> Void in
            guard let _self = self else {return}
						
						_self._antenna1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End)
						_self._antenna2.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End, completion: {[weak self] () -> Void in
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
		rotationAnimFrom1.toValue = -M_PI_2 * 0.2
		rotationAnimFrom1.completionBlock = {[weak self] anim in
      guard let _self = self else {return}

			let rotationAnimTo1 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
			rotationAnimTo1.toValue = 0
			_self._antenna1.pop_addAnimation(rotationAnimTo1, forKey: "RotationAnimTo")
		}
		_antenna1.pop_addAnimation(rotationAnimFrom1, forKey: "RotationAnimFrom")
		
		let rotationAnimFrom2 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		rotationAnimFrom2.toValue = M_PI_2 * 0.2
		rotationAnimFrom2.completionBlock = {[weak self] anim in
      guard let _self = self else {return}

			let rotationAnimTo2 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
			rotationAnimTo2.toValue = 0
			rotationAnimTo2.completionBlock = { anim in
				let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
				dispatch_after(dispatchTime, dispatch_get_main_queue(), {[weak self] () -> Void in
          guard let _self = self else {return}

					_self.televisionAnimation()
				})
			}
			_self._antenna2.pop_addAnimation(rotationAnimTo2, forKey: "RotationAnimTo")
		}
		_antenna2.pop_addAnimation(rotationAnimFrom2, forKey: "RotationAnimFrom")
	}
	
	//Snow Animation
	
	func snowAnimation () {
		for (index, snow) in  _snowAry.enumerate() {
			let opacityAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
			opacityAnim.toValue = 1.0
			opacityAnim.repeatForever = true
			opacityAnim.autoreverses = true
			opacityAnim.duration = 0.5
			opacityAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * 0.7
			snow.pop_addAnimation(opacityAnim, forKey: "OpacityAnimation")
		}
	}
}
















