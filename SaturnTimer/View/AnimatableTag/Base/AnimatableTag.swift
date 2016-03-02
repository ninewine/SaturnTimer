//
//  AnimatableTag.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/28/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import pop

class AnimatableTag: UIControl, HighlightableProtocol {
	
	var _pausing = false
  var _fixedSize: CGSize = CGSizeZero
  var _contentView = UIView()
  var st_highlighted: Bool {
    get {
      return _highlighted
    }
  }
  private var _highlighted = false
  
  private let _innerButton = UIButton(type: .Custom)
  
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	required override init (frame: CGRect) {
		super.init(frame: frame)
		self.viewConfig()
  }
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.viewConfig()
	}
	
	func viewConfig () {
    backgroundColor = UIColor.clearColor()
    clipsToBounds = false
    
    _contentView.backgroundColor = UIColor.clearColor()
    _contentView.frame = CGRect(
      x: (frame.width - _fixedSize.width) * 0.5,
      y: (frame.height - _fixedSize.height) * 0.5,
      width: _fixedSize.width,
      height: _fixedSize.height
    )
    addSubview(_contentView)
    
    let innerButtonSize = CGSize(width: 50, height: 50)
    _innerButton.frame = CGRect(
      x: (frame.width - innerButtonSize.width) * 0.5,
      y: (frame.height - innerButtonSize.height) * 0.5,
      width: innerButtonSize.width,
      height: innerButtonSize.height
    )
    addSubview(_innerButton)
    
    _innerButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext {[weak self] (_) -> Void in
      self?.sendActionsForControlEvents(.TouchUpInside)
    }
    
		self.registerNotification()
	}
	
	func registerNotification () {
		NSNotificationCenter
			.defaultCenter()
			.rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil)
			.takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.stopAnimation()
		}
		
		NSNotificationCenter
			.defaultCenter()
			.rac_addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil)
			.takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.startAnimation()
		}
	}
  
  func currentAppearenceColor () -> CGColorRef {
    return _highlighted ? HelperColor.primaryColor.CGColor : HelperColor.lightGrayColor.CGColor
  }
  
  func setHighlightStatus(highlighted: Bool, animated: Bool) {
    if highlighted == _highlighted {
      return
    }
    
    _highlighted = highlighted
    
    guard let layers = layersNeedToBeHighlighted() else {return}
    
    let _ = layers.flatMap { (layer) -> CAShapeLayer in
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
  
  func layersNeedToBeHighlighted () -> [CAShapeLayer]? {
    // for override
    return nil
  }

	func startAnimation () {
		// for override
	}
	
	func stopAnimation () {
		// for override
	}
}
