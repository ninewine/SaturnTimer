//
//  Plate.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/18/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop

class Plate: AnimatableTag {
	private let _fixedSize: CGSize = CGSizeMake(25, 21)
	
	private let _top: CAShapeLayer = CAShapeLayer()
	private let _topHandle1: CAShapeLayer = CAShapeLayer()
	private let _topHandle2: CAShapeLayer = CAShapeLayer()
	private let _bottom: CAShapeLayer = CAShapeLayer()
	
	private let _lid: CALayer = CALayer()
	
	private let _duration: CFTimeInterval = 1.0
	private var _originalLidPositionY: CGFloat = 0.0
	
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
		
		_lid.frame = CGRect(x: -frame.width * 0.5, y: frame.height * 0.5 * 0.5, width: frame.width, height: frame.height * 0.5)
		_lid.anchorPoint = CGPoint(x: 0, y: 1)
		_originalLidPositionY = _lid.position.y
		
		layer.addSublayer(_lid)
		
		_top.path = _PlateLayerPath.topPath.CGPath
		_topHandle1.path = _PlateLayerPath.topHandle1Path.CGPath
		_topHandle2.path = _PlateLayerPath.topHandle2Path.CGPath
		_bottom.path = _PlateLayerPath.bottomPath.CGPath
		
		let layersStroke = [_top, _topHandle1, _topHandle2]
		for layer in layersStroke {
			layer.opaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.lineJoin = kCALineJoinRound
			layer.strokeStart = 0.0
			layer.strokeEnd = 0.0
			layer.strokeColor = HelperColor.primaryColor.CGColor
			layer.fillColor = UIColor.clearColor().CGColor
			_lid.addSublayer(layer)
		}
		
		_topHandle1.lineWidth = 2.0
		
		_bottom.opaque = true
		_bottom.lineCap = kCALineCapRound
		_bottom.lineWidth = 1.5
		_bottom.strokeStart = 0
		_bottom.strokeEnd = 0
		_bottom.strokeColor = HelperColor.primaryColor.CGColor
		_bottom.fillColor = UIColor.clearColor().CGColor
		layer.addSublayer(_bottom)
		
		enterAnimation()
	}
	
	
	override func startAnimation() {
		_pausing = false
		lidAnimation()
	}
	
	override func stopAnimation() {
		_pausing = true

		_lid.removeAllAnimations()
		_lid.position.y = _originalLidPositionY
		_lid.transform = CATransform3DIdentity
	}
	
	// Enter Animation
	
	func enterAnimation () {
		_bottom.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .End)
		_top.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}

			_self._topHandle1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End) {[weak self] () -> Void in
        guard let _self = self else {return}

				_self._topHandle2.pathStokeAnimationFrom(0.5, to: 0.0, duration: _self._duration * 0.5, type: .Start)
				_self._topHandle2.pathStokeAnimationFrom(0.5, to: 1.0, duration: _self._duration * 0.5, type: .End) {[weak self] () -> Void in
          guard let _self = self else {return}

					_self.lidAnimation()
				}
			}
		}
	}
	
	
	// Lid Animation
	
	func lidAnimation () {
		if _pausing {
			return
		}
		let moveUpAnim = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
		moveUpAnim.duration = 0.5
		moveUpAnim.toValue = _originalLidPositionY - 3
		moveUpAnim.completionBlock = {[weak self] anim in
      guard let _self = self else {return}

			let moveDownAnim = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
			moveDownAnim.duration = 0.5
			moveDownAnim.toValue = _self._originalLidPositionY
			moveDownAnim.completionBlock = {anim in
				
			}
			_self._lid.pop_addAnimation(moveDownAnim, forKey: "MoveUpAnimation")
		}
		_lid.pop_addAnimation(moveUpAnim, forKey: "MoveUpAnimation")
		
		let rotationAnimFrom = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
		rotationAnimFrom.duration = 0.5
		rotationAnimFrom.toValue = -M_PI_4 * 0.5
		rotationAnimFrom.completionBlock = {[weak self] anim in
      guard let _self = self else {return}
			
			let rotationAnimTo = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
			rotationAnimTo.duration = 0.5
			rotationAnimTo.toValue = 0
			rotationAnimTo.completionBlock = {anim in

				let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
				dispatch_after(dispatchTime, dispatch_get_main_queue(), {[weak self] () -> Void in
          guard let _self = self else {return}

					_self.lidAnimation()
					})
			}
			_self._lid.pop_addAnimation(rotationAnimTo, forKey: "RotationAnim")
		}
		_lid.pop_addAnimation(rotationAnimFrom, forKey: "RotationAnim")
		
	}
}
