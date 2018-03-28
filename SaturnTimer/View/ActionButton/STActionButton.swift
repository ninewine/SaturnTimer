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
  case none, menu, stop, close, back
}

class STActionButton: UIButton {
  var type: ActionButtonType = .none {
    willSet {
      changeButtonType(newValue)
    }
  }
  
  fileprivate var _ring: AnimatableRingLayer!
  fileprivate var _square: AnimatableSquareLayer!
  fileprivate var _gear: AnimatableGearLayer!
  fileprivate var _cross: AnimatableCrossLayer!
  fileprivate var _arrow: AnimatableArrowLayer!

  fileprivate var _showingAnimatableLayer: AnimatableLayer?
  
  fileprivate let _contentLayer: CALayer = CALayer ()
  
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
    backgroundColor = UIColor.clear
    
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

    reactive.producer(forKeyPath: "bounds").startWithValues {[weak self] (rect) in
      self?.resetContentLayer()
    }
    
    reactive.controlEvents(.touchDown).observeValues {[weak self] (button) in
      self?._ring.setHighlightStatus(true, animated: true)
      self?._showingAnimatableLayer?.setHighlightStatus(true, animated: true)
    }
    
    reactive.controlEvents([.touchUpInside, .touchUpOutside, .touchCancel]).observeValues {[weak self] (button) in
      self?._ring.setHighlightStatus(false, animated: true)
      self?._showingAnimatableLayer?.setHighlightStatus(false, animated: true)
    }
  }
  
  func resetContentLayer () {
    _contentLayer.position = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
  }
  
  func changeButtonType (_ type: ActionButtonType) {
    if type == self.type {
      return
    }
    
    if _showingAnimatableLayer == nil {
      _contentLayer.addSublayer(_gear)
      _showingAnimatableLayer = _gear
      _gear.transitionIn(nil)
    }
    else {
      isUserInteractionEnabled = false
      _showingAnimatableLayer?.transitionOut({[weak self] () -> () in
        guard let _self = self else {return}
        
        _self._showingAnimatableLayer?.removeFromSuperlayer()
        switch type {
        case .menu:
          _self._contentLayer.addSublayer(_self._gear)
          _self._showingAnimatableLayer = _self._gear
          break
        case .stop:
          _self._contentLayer.addSublayer(_self._square)
          _self._showingAnimatableLayer = _self._square
          break
        case .close:
          _self._contentLayer.addSublayer(_self._cross)
          _self._showingAnimatableLayer = _self._cross
          break
        case .back:
          _self._contentLayer.addSublayer(_self._arrow)
          _self._showingAnimatableLayer = _self._arrow
          break
        default:
          break
        }
        
        _self._showingAnimatableLayer?.transitionIn({[weak self] () -> () in
          self?.isUserInteractionEnabled = true
        })
      })
    }
  }
  
}
