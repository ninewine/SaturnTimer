//
//  STComet.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 3/1/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa

protocol STCometDelegate: NSObjectProtocol {
  func cometAnimationDidStop (_ comet: STComet)
}

class STComet: CALayer, CAAnimationDelegate {
  
  weak var comet_delegate: STCometDelegate?
  
  fileprivate let _innerLayer = CAShapeLayer()
  fileprivate let _maxRectInset: CGFloat = 100.0
  fileprivate let _maxInnerLayerY: CGFloat = 50.0
  fileprivate let _flyDuration = 8.0
  
  convenience init(size: CGSize, color: CGColor) {
    self.init()
    
    let screenBounds = UIScreen.main.bounds
    let randomRectInset = CGFloat.random * _maxRectInset
    frame = screenBounds.insetBy(dx: randomRectInset * 0.5, dy: randomRectInset)
    position = CGPoint(x: screenBounds.width * 0.5, y: screenBounds.height * 0.5)
    
    _innerLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height)).cgPath
    _innerLayer.strokeColor = UIColor.clear.cgColor
    _innerLayer.fillColor = color
    _innerLayer.opacity = 0.8
    addSublayer(_innerLayer)
    
    let randomAngle = CGFloat.random * CGFloat(M_PI) * 2
    setAffineTransform(CGAffineTransform(rotationAngle: randomAngle))
  }
  
  func run () {
    let path = UIBezierPath(ovalIn: bounds)
    
    let pathAnim = CAKeyframeAnimation(keyPath: "position")
    pathAnim.path = path.cgPath
    pathAnim.calculationMode = kCAAnimationPaced
    
    let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnim.keyTimes = [0.0, 0.2, 1.0]
    opacityAnim.values = [0.0, 0.8, 0.0]
    
    let animGroup = CAAnimationGroup()
    animGroup.delegate = self
    animGroup.duration = _flyDuration + Double.random * 0.4
    animGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animGroup.animations = [pathAnim, opacityAnim]
    _innerLayer.add(animGroup, forKey: "CometAnimation")
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    removeFromSuperlayer()
    comet_delegate?.cometAnimationDidStop(self)
  }
}

class STCometManager: NSObject, STCometDelegate {
  weak var contentView: UIView?
  
  
  fileprivate var comets = [STComet]()
  fileprivate let maxCometAmount: Int = 20
  fileprivate let minCometDiameter: CGFloat = 1.0
  fileprivate let bornInterval: TimeInterval = 0.5
  fileprivate var timer: Timer?
  

  override init () {
    super.init()
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationWillResignActive)
      .take(during: reactive.lifetime)
      .observeValues {[weak self] (notification) in
        self?.stop()
    }
    
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationWillEnterForeground)
      .take(during: reactive.lifetime)
      .observeValues {[weak self] (notification) in
        self?.resume()
    }
  }
  
  func startWithContentView(_ contentView: UIView?) {
    guard let aView = contentView else {
      print("Comet Manager must have a contentView")
      return
    }
    
    self.contentView = aView
    
    timer = Timer(timeInterval: bornInterval, target: self, selector: #selector(STCometManager.makeComet), userInfo: nil, repeats: true)
    if timer != nil {
      RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
  }
  
  func resume () {
    timer?.invalidate()
    timer = nil
    timer = Timer(timeInterval: bornInterval, target: self, selector: #selector(STCometManager.makeComet), userInfo: nil, repeats: true)
    if timer != nil {
      RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
    
    for comet in comets {
      comet.removeAllAnimations()
      comet.removeFromSuperlayer()
    }
    
    comets.removeAll()
  }
  
  
  func makeComet () {
    if comets.count >= maxCometAmount {
      return
    }
    
    let sizeSeed = CGFloat(drand48())
    let diamiter = minCometDiameter + (sizeSeed * 1.0)
    
    let comet = STComet(size: CGSize(width: diamiter, height: diamiter), color: HelperColor.lightGrayColor.cgColor)
    comet.comet_delegate = self
    contentView?.layer.addSublayer(comet)
    comets.append(comet)
    comet.run()
  }
  
  fileprivate func removeComet (_ comet: STComet) {
    comets.remove(comet)
  }
  
  //MARK: - Comet Delegate
  
  func cometAnimationDidStop(_ comet: STComet) {
    removeComet(comet)
  }
}
