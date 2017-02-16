//
//  STPlayButton.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/23/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import pop
import ReactiveCocoa
import ReactiveSwift
import Result
import QorumLogs

enum STPlayButtonBarShape: Int {
  case bar, triangle
  
  static func preferShareOfStauts (_ hightlight: Bool) -> STPlayButtonBarShape{
    return hightlight ? .triangle : .bar
  }
}

class STPlayButton: UIView, CAAnimationDelegate {
  
  var highlighting: Bool = false {
    willSet {
      changeButtonAppearance(newValue)
    }
  }
  
  var enabled: Bool = false {
    willSet {
      enableButton(newValue)
    }
  }
  
  var pressedSignal: Signal<STPlayButton, NoError>!
  
  fileprivate let _fixedSize: CGSize = CGSize(width: 90, height: 90)
  
  fileprivate let _pauseBar1: CAShapeLayer = CAShapeLayer()
  fileprivate let _pauseBar2: CAShapeLayer = CAShapeLayer()
  fileprivate let _background: CAShapeLayer = CAShapeLayer()
  
  fileprivate let _button: UIButton = UIButton()
  
  fileprivate var pressedObserver: Observer<STPlayButton, NoError>?
  
  fileprivate var currenShape: STPlayButtonBarShape = .bar
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: _fixedSize.width, height: _fixedSize.height))
    viewConfig()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    frame.size.width = _fixedSize.width
    frame.size.height = _fixedSize.height
    viewConfig()
  }
  
  func viewConfig () {
    let (pressedSignal, pressedObserver) = Signal<STPlayButton, NoError>.pipe()
    self.pressedSignal = pressedSignal
    self.pressedObserver = pressedObserver
    
    _background.path = _STPlayButtonPath.backgroundPath.cgPath
    _background.fillColor = HelperColor.disabeldColor.cgColor
    layer.addSublayer(_background)
    
    _pauseBar1.path = _STPlayButtonPath.playBar1Path.cgPath
    _pauseBar1.fillColor = HelperColor.st_backgroundColor.cgColor
    layer.addSublayer(_pauseBar1)
    
    _pauseBar2.path = _STPlayButtonPath.playBar2Path.cgPath
    _pauseBar2.fillColor = HelperColor.st_backgroundColor.cgColor
    layer.addSublayer(_pauseBar2)

    _button.frame = bounds
    _button.backgroundColor = UIColor.clear
    _button.addTarget(self, action: #selector(STPlayButton.pressed), for: .touchUpInside)
    addSubview(_button)
  }

  func pressed () {
    if !enabled {
      return
    }
    
    HelperNotification.checkAccessibility {[unowned self] (granted, ignore) -> Void in
      if granted || ignore{
        self.highlighting = !self.highlighting
        self.pressedObserver?.send(value: self)
        self.isUserInteractionEnabled = false
      }
    }
  }
  
  func enableButton (_ enabled: Bool) {
    isUserInteractionEnabled = enabled
    _background.pop_removeAllAnimations()
    let colorAnim = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
    colorAnim?.duration = 0.2
    colorAnim?.toValue =
      enabled
      ? highlighting
        ? HelperColor.playButtonBGColor.cgColor
        : HelperColor.primaryColor.cgColor
      : HelperColor.disabeldColor.cgColor
    _background.pop_add(colorAnim, forKey: "Color Animation")
  }

  func changeButtonAppearance (_ highlighting: Bool) {
    if STPlayButtonBarShape.preferShareOfStauts(highlighting) != currenShape {
      currenShape = STPlayButtonBarShape.preferShareOfStauts(highlighting)
      
      let bar1FromPath = highlighting ? _STPlayButtonPath.playBar1Path.cgPath : _STPlayButtonPath.pauseBar1Path.cgPath
      let bar1ToPath = highlighting ? _STPlayButtonPath.pauseBar1Path.cgPath : _STPlayButtonPath.playBar1Path.cgPath
      let bar2FromPath = highlighting ? _STPlayButtonPath.playBar2Path.cgPath : _STPlayButtonPath.pauseBar2Path.cgPath
      let bar2ToPath = highlighting ? _STPlayButtonPath.pauseBar2Path.cgPath : _STPlayButtonPath.playBar2Path.cgPath
      
      _pauseBar1.path = bar1ToPath
      let pathAnim1 = CABasicAnimation(keyPath: "path")
      pathAnim1.fromValue = bar1FromPath
      pathAnim1.toValue = bar1ToPath
      pathAnim1.duration = 0.2
      self._pauseBar1.add(pathAnim1, forKey: "PathAnimation")
      
      _pauseBar2.path = bar2ToPath
      let pathAnim2 = CABasicAnimation(keyPath: "path")
      pathAnim2.fromValue = bar2FromPath
      pathAnim2.toValue = bar2ToPath
      pathAnim2.duration = 0.2
      pathAnim2.delegate = self
      _pauseBar2.add(pathAnim2, forKey: "PathAnimation")
    }
   
    let bgToColor =
      enabled
        ? highlighting
          ? HelperColor.playButtonBGColor.cgColor
          : HelperColor.primaryColor.cgColor
        : HelperColor.disabeldColor.cgColor
    let colorAnim = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
    colorAnim?.duration = 0.2
    colorAnim?.toValue = bgToColor
    _background.pop_add(colorAnim, forKey: "ColorAnimtion")
  }
  
  //MARK - Animation Delegate
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      isUserInteractionEnabled = true
    }
  }
  
}
