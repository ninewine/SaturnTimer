//
//  STStopOrMenuButton.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import QorumLogs

enum ActionButtonType: Int {
  case None, Menu, Stop, Close, Back
}

class STActionButton: UIButton {
  var type: ActionButtonType = .None {
    willSet {
      changeButtonType(newValue)
    }
  }
  
  private var _ring: AnimatableRingLayer!
  private var _square: AnimatableSquareLayer!
  private var _gear: AnimatableGearLayer!
  private var _cross: AnimatableCrossLayer!
  private var _arrow: AnimatableArrowLayer!

  private var _showingAnimatableLayer: AnimatableLayer?
  
  private let _contentLayer: CALayer = CALayer ()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configView()
  }
  
  override init (frame: CGRect) {
    super.init(frame: frame)
    configView()
  }
  
  func configView () {
    backgroundColor = UIColor.clearColor()
    
    _contentLayer.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
    _contentLayer.position = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
    layer.addSublayer(_contentLayer)
    
    _ring = AnimatableRingLayer(frame: _contentLayer.bounds)
    _contentLayer.addSublayer(_ring)
    _ring.transitionIn(nil)
    
    _square = AnimatableSquareLayer(frame: _contentLayer.bounds)
    _cross = AnimatableCrossLayer(frame: _contentLayer.bounds)
    _gear = AnimatableGearLayer(frame: _contentLayer.bounds)
    _arrow = AnimatableArrowLayer(frame: _contentLayer.bounds)

    
    DynamicProperty(object: self, keyPath: "bounds").signal.observeNext {[weak self] (_) -> () in
      guard let _self = self else {return}
      _self.resetContentLayer()
    }
    
    rac_signalForControlEvents(.TouchDown).subscribeNext {[weak self] (button) -> Void in
      self?._ring.setHighlightStatus(true, animated: true)
      self?._showingAnimatableLayer?.setHighlightStatus(true, animated: true)
    }
    
    rac_signalForControlEvents([.TouchUpInside, .TouchUpOutside, .TouchCancel]).subscribeNext {[weak self] (button) -> Void in
      self?._ring.setHighlightStatus(false, animated: true)
      self?._showingAnimatableLayer?.setHighlightStatus(false, animated: true)
    }
  }
  
  func resetContentLayer () {
    _contentLayer.position = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
  }
  
  func changeButtonType (type: ActionButtonType) {
    if type == self.type {
      return
    }
    
    if _showingAnimatableLayer == nil {
      _contentLayer.addSublayer(_gear)
      _showingAnimatableLayer = _gear
      _gear.transitionIn(nil)
    }
    else {
      userInteractionEnabled = false
      _showingAnimatableLayer?.transitionOut({[weak self] () -> () in
        guard let _self = self else {return}
        
        _self._showingAnimatableLayer?.removeFromSuperlayer()
        switch type {
        case .Menu:
          _self._contentLayer.addSublayer(_self._gear)
          _self._showingAnimatableLayer = _self._gear
          break
        case .Stop:
          _self._contentLayer.addSublayer(_self._square)
          _self._showingAnimatableLayer = _self._square
          break
        case .Close:
          _self._contentLayer.addSublayer(_self._cross)
          _self._showingAnimatableLayer = _self._cross
          break
        case .Back:
          _self._contentLayer.addSublayer(_self._arrow)
          _self._showingAnimatableLayer = _self._arrow
          break
        default:
          break
        }
        
        _self._showingAnimatableLayer?.transitionIn({[weak self] () -> () in
          self?.userInteractionEnabled = true
        })
      })
    }
  }
  
}
