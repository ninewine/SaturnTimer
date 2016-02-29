//
//  Saturn.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/17/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop

class Saturn: AnimatableTag {
	
	private let _planet: CAShapeLayer = CAShapeLayer()
	private let _ring: CAShapeLayer = CAShapeLayer()
	private let _light1: CAShapeLayer = CAShapeLayer()
	private let _light2: CAShapeLayer = CAShapeLayer()

	private let _duration: CFTimeInterval = 1.0

	override func viewConfig() {
    _fixedSize = CGSizeMake(30, 24)
    
		super.viewConfig()

		_planet.path = _SaturnLayerPath.planetPath.CGPath
		_ring.path = _SaturnLayerPath.ringPath.CGPath
		_light1.path = _SaturnLayerPath.light1.CGPath
		_light2.path = _SaturnLayerPath.light2.CGPath
		
		let layersStroke = [_planet, _ring, _light1, _light2]
		for layer in layersStroke {
			layer.opaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.miterLimit = 1.5
			layer.strokeStart = 0.0
			layer.strokeEnd = 0.0
			layer.strokeColor = currentAppearenceColor()
			layer.fillColor = UIColor.clearColor().CGColor
			_contentView.layer.addSublayer(layer)
		}
		
		enterAnimation()
	}
	
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_planet, _ring, _light1, _light2]
  }
	
	override func startAnimation() {
		_pausing = false

		ringHeadAnimation()
	}
	
	override func stopAnimation() {
		_pausing = true
		
		_ring.removeAllAnimations()
		_ring.strokeStart = 0.0
		_ring.strokeEnd = 0.0
	}
	
	
	// Enter Animation
	
	func enterAnimation () {
		//Planet
		_planet.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}

			_self._light1.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End, completion: {[weak self] () -> Void in
        guard let _self = self else {return}

				_self._light2.pathStokeAnimationFrom(0.0, to: 1.0, duration: _self._duration * 0.5, type: .End, completion: {[weak self] () -> Void in
          guard let _self = self else {return}

					_self.startAnimation()
					
					})
				})
		}
	}
	
	//Ring Animation
	
	func ringHeadAnimation () {
		if _pausing {
			return
		}

    _ring.removeFromSuperlayer()
    _ring.setValueWithoutImplicitAnimation(0.0, forKey: "strokeStart")
    _ring.setValueWithoutImplicitAnimation(0.0, forKey: "strokeEnd")
    _contentView.layer.addSublayer(_ring)
		
    
		_ring.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration * 0.5, type: .End) {[weak self] () -> Void in
      guard let _self = self else {return}

			_self.ringTailAnimation()
		}
	}
	
	func ringTailAnimation () {
		if _pausing {
			return
		}

		_ring.pathStokeAnimationFrom(0.0, to: 1.0, duration: _duration * 0.5, type: .Start)
			{() -> Void in
				let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
				dispatch_after(dispatchTime, dispatch_get_main_queue(), {[weak self] () -> Void in
          guard let _self = self else {return}

					_self.ringHeadAnimation()
				})

		}
	}
}