//
//  Sandglass.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop

//MARK: - Sandglass

class Sandglass: AnimatableTag, UICollisionBehaviorDelegate {

	private var _glass: _Glass!
	
	private var _sandAppearDuration: Double = 1.0
	
	private let _fixedSize: CGSize = CGSizeMake(20, 29)
	private let _reverseCircleTimeInterval: Double = 4

	private let _sandTop: CAShapeLayer = CAShapeLayer()
	private let _sandBottom: CAShapeLayer = CAShapeLayer()
	private var _sandAnimationStepTop: Int = 0
	private var _sandAnimationStepBottom: Int = 0
	
	private var _particles: [UIView] = []
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init (frame: CGRect) {
		super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, _fixedSize.width, _fixedSize.height))
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		frame.size.width = _fixedSize.width
		frame.size.height = _fixedSize.height
	}
	
	override func viewConfig () {
		super.viewConfig()
		
		backgroundColor = UIColor.clearColor()
		
		_glass = _Glass(frame: bounds)
		addSubview(_glass)
		
		let layersFill = [_sandTop, _sandBottom]
		for layer in layersFill {
			layer.opaque = true
			layer.strokeColor = UIColor.clearColor().CGColor
			layer.fillColor = HelperColor.primaryColor.CGColor
			self.layer.addSublayer(layer)
		}
		
		_glass.glassShowing (_sandAppearDuration)
		startAnimation()
	}
	
	//MARK: - Animation
	override func startAnimation () {
		_pausing = false
		
		_sandTop.opacity = 0.0
		_sandBottom.opacity = 0.0
		
		_sandTop.path = _GlassLayerPath.sandTopLevel1Path.CGPath
		_sandBottom.path = _GlassLayerPath.sandBottomLevel1Path.CGPath
		
		let opacityAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
		opacityAnim.toValue = 1.0
		opacityAnim.duration = _sandAppearDuration
		opacityAnim.animationDidReachToValueBlock = {[weak self] anim in
      guard let _self = self else {return}

      _self.dropSand()
      _self.startTopSandAnimation()
      _self.startBottomSandAnimation()
			
		}
		_sandTop.pop_addAnimation(opacityAnim, forKey: "opacity animation")
		
		let opacityAnim1 = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
		opacityAnim1.toValue = 1.0
		opacityAnim1.duration = _sandAppearDuration
		_sandBottom.pop_addAnimation(opacityAnim1, forKey: "opacity animation")
	}
	
	override func stopAnimation() {
		_pausing = true
		resetSand()
		
		_sandAppearDuration = 1.0
		
		_sandTop.removeAllAnimations()
		_sandTop.opacity = 0.0
		_sandAnimationStepTop = 0
		
		_sandBottom.removeAllAnimations()
		_sandBottom.opacity = 0.0
		_sandAnimationStepBottom = 0
	}
	
	//MARK: Glass Animation
	
	func completeASandCircle () {
		if _pausing {
			return
		}
		_sandTop.opacity = 0.0
		_sandBottom.opacity = 0.0
		resetSand()
		
		_glass.reverseGlass({[weak self] () -> Void in
      guard let _self = self else {return}
      _self._sandAppearDuration = 0.2
      _self.startAnimation()
			
		})
	}
	
	//MARK: Sand Animation
	
	func startTopSandAnimation () {
		animateTopSandWithStep(_sandAnimationStepTop)
	}
	
	func startBottomSandAnimation () {
		animateBottomSandWithStep(_sandAnimationStepBottom)
	}
	
	func animateTopSandWithStep (step: Int) {
		if step >= _GlassLayerPath.sandPathsTop.count - 1 || _pausing {
			_sandAnimationStepTop = 0
			completeASandCircle()
			return
		}
		
		let duration: Double = _reverseCircleTimeInterval / Double(_GlassLayerPath.sandPathsTop.count)
		
		let pathAnim = CABasicAnimation(keyPath: "path")
		pathAnim.fromValue = _GlassLayerPath.sandPathsTop[step].CGPath
		pathAnim.toValue = _GlassLayerPath.sandPathsTop[step+1].CGPath
		pathAnim.duration = duration
		pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		pathAnim.setValue("SandAnimationTop", forKey: "animation")
		pathAnim.delegate = self
		_sandTop.st_applyAnimation(pathAnim)
	}
	
	func animateBottomSandWithStep (step: Int) {
		if step >= _GlassLayerPath.sandPathsBottom.count - 1 || _pausing{
			_sandAnimationStepBottom = 0
			return
		}
		
		let duration: Double = _reverseCircleTimeInterval / Double(_GlassLayerPath.sandPathsBottom.count)
		
		let pathAnim = CABasicAnimation(keyPath: "path")
		pathAnim.fromValue = _GlassLayerPath.sandPathsBottom[step].CGPath
		pathAnim.toValue = _GlassLayerPath.sandPathsBottom[step+1].CGPath
		pathAnim.duration = duration
		pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		pathAnim.setValue("SandAnimationBottom", forKey: "animation")
		pathAnim.delegate = self
		_sandBottom.st_applyAnimation(pathAnim)
	}
	
	func dropSand () {
		if _particles.count == 0 {
			_particles = (0...12).flatMap({ (_) -> UIView? in
				let particle = UIView(frame: CGRectMake(frame.width * 0.5, frame.height * 0.5, 1, 1))
				particle.backgroundColor = HelperColor.primaryColor
				addSubview(particle)
				return particle
			})
		}
	
		for (index, particle) in _particles.enumerate() {
			let gap = Double(index) * 0.23
			addSubview(particle)

			UIView.animateWithDuration(0.4, delay: gap, options: UIViewAnimationOptions.CurveLinear, animations: {[weak self] () -> Void in
        guard let _self = self else {return}
        
        particle.center = CGPointMake(_self.frame.width * 0.5, _self.frame.height - 2)
				
				}, completion: { (flag) -> Void in
					particle.removeFromSuperview()
			})
		}
	}
	
	func resetSand () {
		_particles =  _particles.map { (particle) -> UIView in
			particle.center = CGPointMake(frame.width * 0.5, frame.height * 0.5)
			particle.removeFromSuperview()
			return particle
		}
	}
	
	//MARK: Animation Delegate
	
	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if _pausing {
			return
		}
		
		if let value = anim.valueForKey("animation") as? String {
			if value == "SandAnimationTop" {
				_sandAnimationStepTop++
				animateTopSandWithStep(_sandAnimationStepTop)
			}
			else if value == "SandAnimationBottom" {
				_sandAnimationStepBottom++
				animateBottomSandWithStep(_sandAnimationStepBottom)
			}
		}
	}
}

//MARK: - _Glass

class _Glass: UIView {
	let _top: CAShapeLayer = CAShapeLayer()
	let _topGlass: CAShapeLayer = CAShapeLayer()
	let _base: CAShapeLayer = CAShapeLayer()
	let _baseGlass: CAShapeLayer = CAShapeLayer()
	
	//MARK: Private
	private var _reversed = false
	private var _reversing = false
	
	//MARK: Method
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		_top.path = _GlassLayerPath.topPath.CGPath
		_topGlass.path = _GlassLayerPath.topGlassPath.CGPath
		_base.path = _GlassLayerPath.basePath.CGPath
		_baseGlass.path = _GlassLayerPath.baseGlassPath.CGPath
		
		let layersStroke = [_top, _base, _topGlass, _baseGlass]
		for layer in layersStroke {
			layer.opaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.miterLimit = 1.5
			layer.strokeStart = 0.5
			layer.strokeEnd = 0.5
			layer.strokeColor = HelperColor.primaryColor.CGColor
			layer.fillColor = UIColor.clearColor().CGColor
			self.layer.addSublayer(layer)
		}
	}
	
	func glassShowing (duration: Double) {
		let layers = [_top, _base, _topGlass, _baseGlass]
		for layer in layers {
			layer.pathStokeAnimationFrom(0.5 ,to: 0.0, duration: duration, type: .Start)
			layer.pathStokeAnimationFrom(0.5 ,to: 1.0, duration: duration, type: .End)
		}
	}
	
	func reverseGlass (completion :(()->Void)?) {
		if _reversing {
			return
		}
		_reversing = true
		
		let reverseAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		reverseAnim.springSpeed = 15
		reverseAnim.springBounciness = 5
		reverseAnim.fromValue = _reversed ? -M_PI : 0
		reverseAnim.toValue = _reversed ? 0 : M_PI
		reverseAnim.animationDidReachToValueBlock = {[weak self] anim in
			if let _self = self {
				_self._reversing = false
			}
			if let block = completion {
				block()
			}
		}
		layer.pop_addAnimation(reverseAnim, forKey: "glass rotation")
		_reversed = !_reversed
	}
}
