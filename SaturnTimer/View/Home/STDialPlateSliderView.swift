//
//  STDialPlateSliderView.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import QorumLogs
import ReactiveCocoa
import ReactiveSwift
import pop

class STDialPlateSliderView: UIView {
  
  var active: Bool = false
  var enabled: Bool = false {
    willSet {
      dazzlelightAnimation(newValue)
    }
  }
  
  let progress: MutableProperty<Double> = MutableProperty(0.0)  //From 0.0 to 1.0
  
  var ovalCenter: CGPoint?
  var ovalRadius: CGFloat?
  var zeroPointCenter = CGPoint.zero

  fileprivate var degree: CGFloat = 0
  fileprivate let imageLayer = CALayer()
  fileprivate let dazzlelightLayer = CALayer()
    
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
  }
  
  init (image: UIImage) {
    let width: CGFloat = 40.0
    let height: CGFloat = width
    super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    
    backgroundColor = UIColor.clear
    let size = image.size
    imageLayer.frame = CGRect(
      x: (width - size.width) * 0.5,
      y: (height - size.height) * 0.5,
      width: size.width,
      height: size.height
    )
    imageLayer.contents = image.cgImage
    layer.addSublayer(imageLayer)
    
    let dazzlelightFrame = imageLayer.frame.insetBy(dx: -4, dy: -4)
    dazzlelightLayer.frame = dazzlelightFrame
    dazzlelightLayer.contents = UIImage(named: "pic-dazzlelight")?.cgImage
    layer.insertSublayer(dazzlelightLayer, below: imageLayer)
    
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationWillResignActive)
      .take(during: reactive.lifetime)
      .observeValues({[weak self] (notification) in
        self?.dazzlelightLayer.removeAllAnimations()
    })
    
    NotificationCenter.default
      .reactive
      .notifications(forName: NSNotification.Name.UIApplicationWillEnterForeground)
      .take(during: reactive.lifetime)
      .observeValues({[weak self] (notification) in
        guard let _self = self else {return}
        let enabled = _self.enabled
        _self.enabled = enabled
    })
  }
  
  func dazzlelightAnimation (_ enabled: Bool) {
    if enabled {
      dazzlelightLayer.opacityAnimation(0.0, to: 1.0, duration: 1.0, completion: {[weak self] () -> Void in
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.fromValue = NSValue(cgPoint:CGPoint(x: 1.0, y: 1.0))
        scaleAnim?.toValue = NSValue(cgPoint:CGPoint(x: 1.2, y: 1.2))
        scaleAnim?.duration = 1.5
        scaleAnim?.autoreverses = true
        scaleAnim?.repeatForever = true
        self?.dazzlelightLayer.pop_add(scaleAnim, forKey: "ScaleAnimation")
      })
    }
    else {
      dazzlelightLayer.opacityAnimation(1.0, to: 0.0, duration: 1.0, completion: {[weak self] () -> Void in
        self?.dazzlelightLayer.pop_removeAllAnimations()
      })
    }
  }
  
  func slideWithRefrencePoint (_ point: CGPoint) {
    guard let center = ovalCenter, let radius = ovalRadius else {
      print("Slide must have a oval center and a radius")
      return
    }
    
    let transformedPoint = transformPoint(point, coordinateSystemCenter: center)
    let factor: CGFloat = transformedPoint.y < 0 ? -1.0 : 1.0
    
    let (oneQuadrantRadian, fourQuadrantRadian) = calculateDeltaAngle(point)
    
    let moveToDegree = fourQuadrantRadian * 180 / CGFloat(M_PI)
  
    let moveToProgress: Double = Double(moveToDegree) / 360.0

    let targetX = sin(oneQuadrantRadian) * radius
    let targetY = cos(oneQuadrantRadian) * radius * factor
    
    let outputPoint = transformPoint(
      CGPoint(x: targetX, y: targetY),
      coordinateSystemCenter: CGPoint(x: -center.x, y: -center.y)
    )
    
    let outputOriginPoint = CGPoint(x: outputPoint.x - bounds.width * 0.5, y: outputPoint.y - bounds.height * 0.5)
    
    frame.origin = outputOriginPoint
    
    degree = moveToDegree

    progress.value = moveToProgress
  }

  func slideToProgress (_ progress: Double, duration: Double) {    
    if progress < 0.0 || progress > 1.0 {
      print("Progress must be a value between 0.0 and 1.0")
      return
    }
    guard let center = ovalCenter, let radius = ovalRadius else {
      print("Slide must have a oval center and a radius")
      return
    }
    let radian = 2 * M_PI * progress
    
    let toDegree = CGFloat(radian * 180 / M_PI)
    
    let clockwise = degree < toDegree
    
    degree = toDegree
    
    let x = sin(radian) * Double(radius)
    let y = cos(radian) * Double(radius)
    
    let toPoint = CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    
    
    slideAnimationFrom(self.center, to: toPoint, duration: duration, clockwise: clockwise)
  }
  
  func slideAnimationFrom(_ from: CGPoint, to: CGPoint, duration: Double, clockwise: Bool) {
    guard let center = ovalCenter, let radius = ovalRadius else {
      print("Slide must have a oval center and a radius")
      return
    }
    let (_, fromRadian) = calculateDeltaAngle(from)
    let (_, toRadian) = calculateDeltaAngle(to)

    let path = UIBezierPath()
    path.addArc(withCenter: center, radius: radius, startAngle: fromRadian - CGFloat(M_PI_2), endAngle: toRadian - CGFloat(M_PI_2), clockwise: clockwise)
    let pathAnim = CAKeyframeAnimation(keyPath: "position")
    pathAnim.path = path.cgPath
    pathAnim.duration = duration
    pathAnim.fillMode = kCAFillModeForwards
    pathAnim.calculationMode = kCAAnimationCubicPaced
    pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    layer.add(pathAnim, forKey: "PositionAnimation")
    self.center = to
  }
  
  func calculateDeltaAngle (_ referncePoint: CGPoint) -> (oneQuadrantRadian: CGFloat, fourQuadrantRadian : CGFloat) {
    guard let center = ovalCenter else {
      print("Slide must have a oval center and  radius")
      return (0, 0)
    }
    
    let transformedPoint = transformPoint(referncePoint, coordinateSystemCenter: center)
    
    let referencePointRadius = sqrt(pow(transformedPoint.x, 2) + pow(transformedPoint.y, 2))
    let oneQuadrantRadian = asin(transformedPoint.x / referencePointRadius)
    
    var fourQuadrantRadian:CGFloat = 0.0
    
    if transformedPoint.y > 0 {
      fourQuadrantRadian = CGFloat(M_PI) - oneQuadrantRadian
    }
    else if transformedPoint.x < 0 && transformedPoint.y <= 0 {
      fourQuadrantRadian = CGFloat(M_PI * 2) + oneQuadrantRadian
    }
    else {
      fourQuadrantRadian = oneQuadrantRadian
    }
    return (oneQuadrantRadian, fourQuadrantRadian)
  }
  
  func transformPoint (_ point: CGPoint, coordinateSystemCenter center: CGPoint) -> CGPoint {
    return CGPoint(
      x: point.x - center.x,
      y: point.y - center.y
    )
  }

}
