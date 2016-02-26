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
import pop

enum SlidingDirection: Int {
  case Forward, Backward
}

class STDialPlateSliderView: UIView {
  
  var active: Bool = false
  let progress: MutableProperty<Double> = MutableProperty(0.0)  //From 0.0 to 1.0
  
  var ovalCenter: CGPoint?
  var ovalRadius: CGFloat?
  var zeroPointCenter = CGPointZero

  private var degree: CGFloat = 0
  private let imageLayer = CALayer()
  
  private var direction: SlidingDirection = .Forward
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
  }
  
  init (image: UIImage) {
    let width: CGFloat = 40.0
    let height: CGFloat = width
    super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    
    backgroundColor = UIColor.clearColor()
    let size = image.size
    imageLayer.frame = CGRect(
      x: (width - size.width) * 0.5,
      y: (height - size.height) * 0.5,
      width: size.width,
      height: size.height
    )
    imageLayer.contents = image.CGImage
    layer.addSublayer(imageLayer)
    
//    DynamicProperty(object: self, keyPath: "frame").signal.observeNext { (frame) -> () in
//      print(frame)
//    }
  }
  
  
  func slideWithRefrencePoint (point: CGPoint) {
    guard let center = ovalCenter, let radius = ovalRadius else {
      print("Slide must has the oval center and radius")
      return
    }
    
    let transformedPoint = transformPoint(point, coordinateSystemCenter: center)
    let factor: CGFloat = transformedPoint.y < 0 ? -1.0 : 1.0
    
    let (oneQuadrantRadian, fourQuadrantRadian) = calculateDeltaAngle(point)
    
    let moveToDegree = fourQuadrantRadian * 180 / CGFloat(M_PI)
  
    let moveToProgress: Double = Double(degree) / 360.0

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
  
//  func slideToZeroPointWithAnimation(duration duration: Double) {
//    if degree > 0.0 {
//      slideAnimationFrom(self.center, to: zeroPointCenter, duration: duration)
//      degree = 0.0
//    }
//  }
//  
  func slideToProgress (progress: Double, duration: Double) {    
    if progress < 0.0 || progress > 1.0 {
      print("Progress must be value between 0.0 and 1.0")
      return
    }
    guard let center = ovalCenter, let radius = ovalRadius else {
      print("Slide must has the oval center and radius")
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
  
  func slideAnimationFrom(from: CGPoint, to: CGPoint, duration: Double, clockwise: Bool) {
    guard let center = ovalCenter, let radius = ovalRadius else {
      print("Slide must has the oval center and radius")
      return
    }
    let (_, fromRadian) = calculateDeltaAngle(from)
    let (_, toRadian) = calculateDeltaAngle(to)

    let path = UIBezierPath()
    path.addArcWithCenter(center, radius: radius, startAngle: fromRadian - CGFloat(M_PI_2), endAngle: toRadian - CGFloat(M_PI_2), clockwise: clockwise)
    let pathAnim = CAKeyframeAnimation(keyPath: "position")
    pathAnim.path = path.CGPath
    pathAnim.duration = duration
    pathAnim.fillMode = kCAFillModeForwards
    pathAnim.calculationMode = kCAAnimationCubicPaced
    pathAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    layer.addAnimation(pathAnim, forKey: "PositionAnimation")
    self.center = to
  }
  
  func calculateDeltaAngle (referncePoint: CGPoint) -> (oneQuadrantRadian: CGFloat, fourQuadrantRadian : CGFloat) {
    guard let center = ovalCenter else {
      print("Slide must has the oval center and radius")
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
  
  func transformPoint (point: CGPoint, coordinateSystemCenter center: CGPoint) -> CGPoint {
    return CGPoint(
      x: point.x - center.x,
      y: point.y - center.y
    )
  }

}
