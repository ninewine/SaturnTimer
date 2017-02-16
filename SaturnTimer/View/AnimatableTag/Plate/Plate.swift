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
	
	fileprivate let _top: CAShapeLayer = CAShapeLayer()
	fileprivate let _topHandle1: CAShapeLayer = CAShapeLayer()
	fileprivate let _topHandle2: CAShapeLayer = CAShapeLayer()
	fileprivate let _bottom: CAShapeLayer = CAShapeLayer()
	
	fileprivate let _lid: CALayer = CALayer()
	
	fileprivate let _duration: CFTimeInterval = 1.0
	fileprivate var _originalLidPositionY: CGFloat = 0.0
	
	override func viewConfig() {
    _fixedSize = CGSize(width: 25, height: 21)
    
		super.viewConfig()
		
		_lid.frame = CGRect(
      x: -_contentView.frame.width * 0.5,
      y: _contentView.frame.height * 0.5 * 0.5,
      width: _contentView.frame.width, height:
      _contentView.frame.height * 0.5
    )
		_lid.anchorPoint = CGPoint(x: 0, y: 1)
		_originalLidPositionY = _lid.position.y
		
		_contentView.layer.addSublayer(_lid)
		
		_top.path = _PlateLayerPath.topPath.cgPath
		_topHandle1.path = _PlateLayerPath.topHandle1Path.cgPath
		_topHandle2.path = _PlateLayerPath.topHandle2Path.cgPath
		_bottom.path = _PlateLayerPath.bottomPath.cgPath
		
		let layersStroke = [_top, _topHandle1, _topHandle2]
		for layer in layersStroke {
			layer.isOpaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.lineJoin = kCALineJoinRound
			layer.strokeStart = 0.0
			layer.strokeEnd = 0.0
			layer.strokeColor = currentAppearenceColor()
			layer.fillColor = UIColor.clear.cgColor
			_lid.addSublayer(layer)
		}
		
		_topHandle1.lineWidth = 2.0
		
		_bottom.isOpaque = true
		_bottom.lineCap = kCALineCapRound
		_bottom.lineWidth = 1.5
		_bottom.strokeStart = 0
		_bottom.strokeEnd = 0
		_bottom.strokeColor = currentAppearenceColor()
		_bottom.fillColor = UIColor.clear.cgColor
		_contentView.layer.addSublayer(_bottom)
		
		enterAnimation()
	}
	
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_top, _topHandle1, _topHandle2, _bottom]
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
		_bottom.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .end)
		_top.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .end) {[weak self] () -> Void in
      guard let _self = self else {return}

			_self._topHandle1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .end) {[weak self] () -> Void in
        guard let _self = self else {return}

				_self._topHandle2.pathStokeAnimationFrom(0.5, to: 0.0, duration: _self._duration * 0.5, type: .start)
				_self._topHandle2.pathStokeAnimationFrom(0.5, to: 1.0, duration: _self._duration * 0.5, type: .end) {[weak self] () -> Void in
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
		moveUpAnim?.duration = 0.5
		moveUpAnim?.toValue = _originalLidPositionY - 3
		moveUpAnim?.completionBlock = {[weak self] anim in
      guard let _self = self else {return}

			let moveDownAnim = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
			moveDownAnim?.duration = 0.5
			moveDownAnim?.toValue = _self._originalLidPositionY
			moveDownAnim?.completionBlock = {anim in
				
			}
			_self._lid.pop_add(moveDownAnim, forKey: "MoveUpAnimation")
		}
		_lid.pop_add(moveUpAnim, forKey: "MoveUpAnimation")
		
		let rotationAnimFrom = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
		rotationAnimFrom?.duration = 0.5
		rotationAnimFrom?.toValue = -M_PI_4 * 0.5
		rotationAnimFrom?.completionBlock = {[weak self] anim in
      guard let _self = self else {return}
			
			let rotationAnimTo = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
			rotationAnimTo?.duration = 0.5
			rotationAnimTo?.toValue = 0
			rotationAnimTo?.completionBlock = {anim in
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { [weak self] in
          self?.lidAnimation()
        })
    
			}
			_self._lid.pop_add(rotationAnimTo, forKey: "RotationAnim")
		}
		_lid.pop_add(rotationAnimFrom, forKey: "RotationAnim")
		
	}
}
