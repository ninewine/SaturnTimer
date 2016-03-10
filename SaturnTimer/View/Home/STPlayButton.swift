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
import Result
import QorumLogs

enum STPlayButtonBarShape: Int {
  case Bar, Triangle
  
  static func preferShareOfStauts (hightlight: Bool) -> STPlayButtonBarShape{
    return hightlight ? .Triangle : .Bar
  }
}

class STPlayButton: UIView {
  
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
  
  private let _fixedSize: CGSize = CGSizeMake(90, 90)
  
  private let _pauseBar1: CAShapeLayer = CAShapeLayer()
  private let _pauseBar2: CAShapeLayer = CAShapeLayer()
  private let _background: CAShapeLayer = CAShapeLayer()
  
  private let _button: UIButton = UIButton()
  
  private var pressedProducer: SignalProducer<Void, NoError>?
  private var pressedObserver: Observer<Void, NoError>?
  
  private var currenShape: STPlayButtonBarShape = .Bar
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, _fixedSize.width, _fixedSize.height))
    viewConfig()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    frame.size.width = _fixedSize.width
    frame.size.height = _fixedSize.height
    viewConfig()
  }
  
  func viewConfig () {
    let (pressedProducer, pressedObserver) = SignalProducer<Void, NoError>.buffer(1)
    self.pressedProducer = pressedProducer
    self.pressedObserver = pressedObserver
    
    _background.path = _STPlayButtonPath.backgroundPath.CGPath
    _background.fillColor = HelperColor.disabeldColor.CGColor
    layer.addSublayer(_background)
    
    _pauseBar1.path = _STPlayButtonPath.playBar1Path.CGPath
    _pauseBar1.fillColor = HelperColor.st_backgroundColor.CGColor
    layer.addSublayer(_pauseBar1)
    
    _pauseBar2.path = _STPlayButtonPath.playBar2Path.CGPath
    _pauseBar2.fillColor = HelperColor.st_backgroundColor.CGColor
    layer.addSublayer(_pauseBar2)

    _button.frame = bounds
    _button.backgroundColor = UIColor.clearColor()
    _button.addTarget(self, action: Selector("pressed"), forControlEvents: .TouchUpInside)
    addSubview(_button)
  }
  
  func pressedSignalProducer () -> SignalProducer<Void, NoError> {
    guard let producer = self.pressedProducer else {
      return SignalProducer(value: ())
    }
    return producer;
  }
  
  func pressed () {
    if !enabled {
      return
    }
    
    HelperNotification.checkAccessibility {[unowned self] (granted, ignore) -> Void in
      if granted || ignore{
        self.highlighting = !self.highlighting
        self.pressedObserver?.sendNext()
        self.userInteractionEnabled = false
      }
    }
  }
  
  func enableButton (enabled: Bool) {
    userInteractionEnabled = enabled
    _background.pop_removeAllAnimations()
    let colorAnim = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
    colorAnim.duration = 0.2
    colorAnim.toValue =
      enabled
      ? highlighting
        ? HelperColor.playButtonBGColor.CGColor
        : HelperColor.primaryColor.CGColor
      : HelperColor.disabeldColor.CGColor
    _background.pop_addAnimation(colorAnim, forKey: "Color Animation")
  }

  func changeButtonAppearance (highlighting: Bool) {
    if STPlayButtonBarShape.preferShareOfStauts(highlighting) != currenShape {
      currenShape = STPlayButtonBarShape.preferShareOfStauts(highlighting)
      
      let bar1FromPath = highlighting ? _STPlayButtonPath.playBar1Path.CGPath : _STPlayButtonPath.pauseBar1Path.CGPath
      let bar1ToPath = highlighting ? _STPlayButtonPath.pauseBar1Path.CGPath : _STPlayButtonPath.playBar1Path.CGPath
      let bar2FromPath = highlighting ? _STPlayButtonPath.playBar2Path.CGPath : _STPlayButtonPath.pauseBar2Path.CGPath
      let bar2ToPath = highlighting ? _STPlayButtonPath.pauseBar2Path.CGPath : _STPlayButtonPath.playBar2Path.CGPath
      
      _pauseBar1.path = bar1ToPath
      let pathAnim1 = CABasicAnimation(keyPath: "path")
      pathAnim1.fromValue = bar1FromPath
      pathAnim1.toValue = bar1ToPath
      pathAnim1.duration = 0.2
      self._pauseBar1.addAnimation(pathAnim1, forKey: "PathAnimation")
      
      _pauseBar2.path = bar2ToPath
      let pathAnim2 = CABasicAnimation(keyPath: "path")
      pathAnim2.fromValue = bar2FromPath
      pathAnim2.toValue = bar2ToPath
      pathAnim2.duration = 0.2
      pathAnim2.delegate = self
      _pauseBar2.addAnimation(pathAnim2, forKey: "PathAnimation")
    }
   
    let bgToColor =
      enabled
        ? highlighting
          ? HelperColor.playButtonBGColor.CGColor
          : HelperColor.primaryColor.CGColor
        : HelperColor.disabeldColor.CGColor
    let colorAnim = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)
    colorAnim.duration = 0.2
    colorAnim.toValue = bgToColor
    _background.pop_addAnimation(colorAnim, forKey: "ColorAnimtion")
  }
  
  //MARK - Animation Delegate
  
  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    if flag {
      userInteractionEnabled = true
    }
  }
}
