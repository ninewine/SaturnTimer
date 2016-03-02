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
  func cometAnimationDidStop (comet: STComet)
}

class STComet: CALayer {
  
  weak var comet_delegate: STCometDelegate?
  
  private let _innerLayer = CAShapeLayer()
  private let _maxRectInset: CGFloat = 100.0
  private let _maxInnerLayerY: CGFloat = 50.0
  private let _flyDuration = 8.0
  
  convenience init(size: CGSize, color: CGColorRef) {
    self.init()
    
    let screenBounds = UIScreen.mainScreen().bounds
    let randomRectInset = CGFloat.random * _maxRectInset
    frame = CGRectInset(screenBounds, randomRectInset * 0.5, randomRectInset)
    position = CGPoint(x: screenBounds.width * 0.5, y: screenBounds.height * 0.5)
    
    _innerLayer.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).CGPath
    _innerLayer.strokeColor = UIColor.clearColor().CGColor
    _innerLayer.fillColor = color
    _innerLayer.opacity = 0.8
    addSublayer(_innerLayer)
    
    let randomAngle = CGFloat.random * CGFloat(M_PI) * 2
    setAffineTransform(CGAffineTransformMakeRotation(randomAngle))
  }
  
  func run () {
    let path = UIBezierPath(ovalInRect: bounds)
    
    let pathAnim = CAKeyframeAnimation(keyPath: "position")
    pathAnim.path = path.CGPath
    pathAnim.calculationMode = kCAAnimationPaced
    
    let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnim.keyTimes = [0.0, 0.2, 1.0]
    opacityAnim.values = [0.0, 0.8, 0.0]
    
    let animGroup = CAAnimationGroup()
    animGroup.delegate = self
    animGroup.duration = _flyDuration + Double.random * 0.4
    animGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animGroup.animations = [pathAnim, opacityAnim]
    _innerLayer.addAnimation(animGroup, forKey: "CometAnimation")
  }
  
  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    removeFromSuperlayer()
    comet_delegate?.cometAnimationDidStop(self)
  }
}

class STCometManager: NSObject, STCometDelegate {
  weak var contentView: UIView?
  
  
  private var comets = [STComet]()
  private let maxCometAmount: Int = 20
  private let minCometDiameter: CGFloat = 1.0
  private let bornInterval: NSTimeInterval = 0.5
  private var timer: NSTimer?
  

  override init () {
    super.init()
    NSNotificationCenter
      .defaultCenter()
      .rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil)
      .takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.stop()
    }
    
    NSNotificationCenter
      .defaultCenter()
      .rac_addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil)
      .takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.resume()
    }
  }
  
  func startWithContentView(contentView: UIView?) {
    guard let aView = contentView else {
      print("Comet Manager must have a contentView")
      return
    }
    
    self.contentView = aView
    
    timer = NSTimer(timeInterval: bornInterval, target: self, selector: Selector("makeComet"), userInfo: nil, repeats: true)
    if timer != nil {
      NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
  }
  
  func resume () {
    timer?.invalidate()
    timer = nil
    timer = NSTimer(timeInterval: bornInterval, target: self, selector: Selector("makeComet"), userInfo: nil, repeats: true)
    if timer != nil {
      NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
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
    
    let comet = STComet(size: CGSize(width: diamiter, height: diamiter), color: HelperColor.lightGrayColor.CGColor)
    comet.comet_delegate = self
    contentView?.layer.addSublayer(comet)
    comets.append(comet)
    comet.run()
  }
  
  private func removeComet (comet: STComet) {
    comets.removeObject(comet)
  }
  
  //MARK: - Comet Delegate
  
  func cometAnimationDidStop(comet: STComet) {
    removeComet(comet)
  }
}
