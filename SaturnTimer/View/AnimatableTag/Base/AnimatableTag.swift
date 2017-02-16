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
  var _fixedSize: CGSize = CGSize.zero
  var _contentView = UIView()
  var st_highlighted: Bool {
    get {
      return _highlighted
    }
  }
  fileprivate var _highlighted = false
  
  fileprivate let _innerButton = UIButton(type: .custom)
  
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
    backgroundColor = UIColor.clear
    clipsToBounds = false
    
    _contentView.backgroundColor = UIColor.clear
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
    
    _innerButton.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      self?.sendActions(for: .touchUpInside)
    }
    
		self.registerNotification()
	}
	
	func registerNotification () {
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationWillResignActive)
      .take(during: reactive.lifetime)
      .observeValues({[weak self] (notification) in
        self?.stopAnimation()
    })
    
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationWillEnterForeground)
      .take(during: reactive.lifetime)
      .observeValues({[weak self] (notification) in
        self?.startAnimation()
    })
  }
  
  func currentAppearenceColor () -> CGColor {
    return _highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
  }
  
  func setHighlightStatus(_ highlighted: Bool, animated: Bool) {
    if highlighted == _highlighted {
      return
    }
    
    _highlighted = highlighted
    
    guard let layers = layersNeedToBeHighlighted() else {return}
    
    let _ = layers.flatMap { (layer) -> CAShapeLayer in
      if animated {
        let type: ShapeLayerColorType? = layer.colorType
        let propertyName = type == .fill ? kPOPShapeLayerFillColor : kPOPShapeLayerStrokeColor
        let colorAnimation = POPBasicAnimation(propertyNamed: propertyName)
        colorAnimation?.duration = 0.2
        colorAnimation?.toValue = highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
        layer.pop_add(colorAnimation, forKey: "ColorAnimation")
      }
      else {
        if layer.colorType == .fill {
          layer.fillColor = highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
        }
        else {
          layer.strokeColor = highlighted ? HelperColor.primaryColor.cgColor : HelperColor.lightGrayColor.cgColor
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
