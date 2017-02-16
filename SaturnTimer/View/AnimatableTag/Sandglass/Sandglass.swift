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

class Sandglass: AnimatableTag, UICollisionBehaviorDelegate, CAAnimationDelegate {

	fileprivate var _glass: _Glass!
	
	fileprivate var _sandAppearDuration: Double = 1.0
	
	fileprivate let _reverseCircleTimeInterval: Double = 4

	fileprivate let _sandTop: CAShapeLayer = CAShapeLayer()
	fileprivate let _sandBottom: CAShapeLayer = CAShapeLayer()
	fileprivate var _sandAnimationStepTop: Int = 0
	fileprivate var _sandAnimationStepBottom: Int = 0
	
	fileprivate var _particles: [UIView] = []
	
	override func viewConfig () {
    _fixedSize = CGSize(width: 20, height: 29)
    
		super.viewConfig()
		
		_glass = _Glass(frame: _contentView.bounds)
		_contentView.addSubview(_glass)
		
		let layersFill = [_sandTop, _sandBottom]
		for layer in layersFill {
			layer.isOpaque = true
			layer.strokeColor = UIColor.clear.cgColor
			layer.fillColor = currentAppearenceColor()
      layer.colorType = .fill
			_contentView.layer.addSublayer(layer)
		}
		
		_glass.glassShowing (_sandAppearDuration)
		startAnimation()
	}
  
  override func setHighlightStatus(_ hightlightd: Bool, animated: Bool) {
    super.setHighlightStatus(hightlightd, animated: animated)

    for particle in _particles {
      particle.backgroundColor = UIColor(cgColor: currentAppearenceColor())
    }
  }
  
  override func layersNeedToBeHighlighted() -> [CAShapeLayer]? {
    return [_glass._top, _glass._topGlass, _glass._base, _glass._baseGlass, _sandTop, _sandBottom]
  }
	
	//MARK: - Animation
	override func startAnimation () {
		_pausing = false
		
		_sandTop.opacity = 0.0
		_sandBottom.opacity = 0.0
		
		_sandTop.path = _GlassLayerPath.sandTopLevel1Path.cgPath
		_sandBottom.path = _GlassLayerPath.sandBottomLevel1Path.cgPath
		
		let opacityAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
		opacityAnim?.toValue = 1.0
		opacityAnim?.duration = _sandAppearDuration
		opacityAnim?.animationDidReachToValueBlock = {[weak self] anim in
      guard let _self = self else {return}

      _self.dropSand()
      _self.startTopSandAnimation()
      _self.startBottomSandAnimation()
			
		}
		_sandTop.pop_add(opacityAnim, forKey: "opacity animation")
		
		let opacityAnim1 = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
		opacityAnim1?.toValue = 1.0
		opacityAnim1?.duration = _sandAppearDuration
		_sandBottom.pop_add(opacityAnim1, forKey: "opacity animation")
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
	
	func animateTopSandWithStep (_ step: Int) {
		if step >= _GlassLayerPath.sandPathsTop.count - 1 || _pausing {
			_sandAnimationStepTop = 0
			completeASandCircle()
			return
		}
		
		let duration: Double = _reverseCircleTimeInterval / Double(_GlassLayerPath.sandPathsTop.count)
		
		let pathAnim = CABasicAnimation(keyPath: "path")
		pathAnim.fromValue = _GlassLayerPath.sandPathsTop[step].cgPath
		pathAnim.toValue = _GlassLayerPath.sandPathsTop[step+1].cgPath
		pathAnim.duration = duration
		pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		pathAnim.setValue("SandAnimationTop", forKey: "animation")
		pathAnim.delegate = self
		_sandTop.st_applyAnimation(pathAnim)
	}
	
	func animateBottomSandWithStep (_ step: Int) {
		if step >= _GlassLayerPath.sandPathsBottom.count - 1 || _pausing{
			_sandAnimationStepBottom = 0
			return
		}
		
		let duration: Double = _reverseCircleTimeInterval / Double(_GlassLayerPath.sandPathsBottom.count)
		
		let pathAnim = CABasicAnimation(keyPath: "path")
		pathAnim.fromValue = _GlassLayerPath.sandPathsBottom[step].cgPath
		pathAnim.toValue = _GlassLayerPath.sandPathsBottom[step+1].cgPath
		pathAnim.duration = duration
		pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		pathAnim.setValue("SandAnimationBottom", forKey: "animation")
		pathAnim.delegate = self
		_sandBottom.st_applyAnimation(pathAnim)
	}
	
	func dropSand () {
		if _particles.count == 0 {
			_particles = (0...12).flatMap({ (_) -> UIView? in
				let particle = UIView(frame: CGRect(x: frame.width * 0.5, y: frame.height * 0.5, width: 1, height: 1))
        particle.backgroundColor = st_highlighted ? HelperColor.primaryColor : HelperColor.lightGrayColor
				addSubview(particle)
				return particle
			})
		}
	
		for (index, particle) in _particles.enumerated() {
			let gap = Double(index) * 0.23
			addSubview(particle)

			UIView.animate(withDuration: 0.4, delay: gap, options: UIViewAnimationOptions.curveLinear, animations: {[weak self] () -> Void in
        guard let _self = self else {return}
        
        particle.center = CGPoint(x: _self.frame.width * 0.5, y: _self.frame.height - 2)
				
				}, completion: { (flag) -> Void in
					particle.removeFromSuperview()
			})
		}
	}
	
	func resetSand () {
		_particles =  _particles.map { (particle) -> UIView in
			particle.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
			particle.removeFromSuperview()
			return particle
		}
	}
	
	//MARK: Animation Delegate
	
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		if _pausing {
			return
		}
		
		if let value = anim.value(forKey: "animation") as? String {
			if value == "SandAnimationTop" {
				_sandAnimationStepTop += 1
				animateTopSandWithStep(_sandAnimationStepTop)
			}
			else if value == "SandAnimationBottom" {
				_sandAnimationStepBottom += 1
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
	fileprivate var _reversed = false
	fileprivate var _reversing = false
	
	//MARK: Method
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		_top.path = _GlassLayerPath.topPath.cgPath
		_topGlass.path = _GlassLayerPath.topGlassPath.cgPath
		_base.path = _GlassLayerPath.basePath.cgPath
		_baseGlass.path = _GlassLayerPath.baseGlassPath.cgPath
		
		let layersStroke = [_top, _base, _topGlass, _baseGlass]
		for layer in layersStroke {
			layer.isOpaque = true
			layer.lineCap = kCALineCapRound
			layer.lineWidth = 1.5
			layer.miterLimit = 1.5
			layer.strokeStart = 0.5
			layer.strokeEnd = 0.5
			layer.strokeColor = HelperColor.lightGrayColor.cgColor
			layer.fillColor = UIColor.clear.cgColor
			self.layer.addSublayer(layer)
		}
	}
	
	func glassShowing (_ duration: Double) {
		let layers = [_top, _base, _topGlass, _baseGlass]
		for layer in layers {
			layer.pathStokeAnimationFrom(0.5 ,to: 0.0, duration: duration, type: .start)
			layer.pathStokeAnimationFrom(0.5 ,to: 1.0, duration: duration, type: .end)
		}
	}
	
	func reverseGlass (_ completion :(()->Void)?) {
		if _reversing {
			return
		}
		_reversing = true
		
		let reverseAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
		reverseAnim?.springSpeed = 15
		reverseAnim?.springBounciness = 5
		reverseAnim?.fromValue = _reversed ? -M_PI : 0
		reverseAnim?.toValue = _reversed ? 0 : M_PI
		reverseAnim?.animationDidReachToValueBlock = {[weak self] anim in
			if let _self = self {
				_self._reversing = false
			}
			if let block = completion {
				block()
			}
		}
		layer.pop_add(reverseAnim, forKey: "glass rotation")
		_reversed = !_reversed
	}
}
