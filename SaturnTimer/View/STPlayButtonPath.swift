//
//  STPlayButtonPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/23/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct _STPlayButtonPath {
  static var backgroundPath : UIBezierPath {
    let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, 90, 90))
    return path
  }
  
  static var pauseBar1Path: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(35.8, 29))
    path.addCurveToPoint(CGPointMake(33.5, 31.29), controlPoint1: CGPointMake(34.53, 29), controlPoint2: CGPointMake(33.5, 30.02))
    path.addLineToPoint(CGPointMake(33.5, 58.71))
    path.addCurveToPoint(CGPointMake(35.8, 61), controlPoint1: CGPointMake(33.5, 59.98), controlPoint2: CGPointMake(34.53, 61))
    path.addLineToPoint(CGPointMake(40.4, 61))
    path.addCurveToPoint(CGPointMake(42.7, 58.71), controlPoint1: CGPointMake(41.67, 61), controlPoint2: CGPointMake(42.7, 59.98))
    path.addLineToPoint(CGPointMake(42.7, 31.29))
    path.addCurveToPoint(CGPointMake(40.4, 29), controlPoint1: CGPointMake(42.7, 30.02), controlPoint2: CGPointMake(41.67, 29))
    path.moveToPoint(CGPointMake(35.8, 29))
    return path
  }
  
  static var pauseBar2Path: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(49.3, 29))
    path.addCurveToPoint(CGPointMake(47, 31.29), controlPoint1: CGPointMake(48.03, 29), controlPoint2: CGPointMake(47, 30.02))
    path.addLineToPoint(CGPointMake(47, 58.71))
    path.addCurveToPoint(CGPointMake(49.3, 61), controlPoint1: CGPointMake(47, 59.98), controlPoint2: CGPointMake(48.03, 61))
    path.addLineToPoint(CGPointMake(53.9, 61))
    path.addCurveToPoint(CGPointMake(56.2, 58.71), controlPoint1: CGPointMake(55.17, 61), controlPoint2: CGPointMake(56.2, 59.98))
    path.addLineToPoint(CGPointMake(56.2, 31.29))
    path.addCurveToPoint(CGPointMake(53.9, 29), controlPoint1: CGPointMake(56.2, 30.02), controlPoint2: CGPointMake(55.17, 29))
    path.moveToPoint(CGPointMake(49.3, 29))
    return path
  }
  
  static var playBar1Path: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(37.8, 28))
    path.addCurveToPoint(CGPointMake(36.5, 30.46), controlPoint1: CGPointMake(36.92, 28.32), controlPoint2: CGPointMake(36.5, 28.94))
    path.addLineToPoint(CGPointMake(36.5, 59.01))
    path.addCurveToPoint(CGPointMake(37.8, 61.65), controlPoint1: CGPointMake(36.5, 60.97), controlPoint2: CGPointMake(37.07, 61.5))
    path.addCurveToPoint(CGPointMake(39.98, 60.97), controlPoint1: CGPointMake(38.68, 62.05), controlPoint2: CGPointMake(39.98, 60.97))
    path.addLineToPoint(CGPointMake(49.5, 54.82))
    path.addLineToPoint(CGPointMake(49.5, 34.93))
    path.addCurveToPoint(CGPointMake(39.98, 28.69), controlPoint1: CGPointMake(49.5, 34.93), controlPoint2: CGPointMake(40.68, 29.22))
    path.addCurveToPoint(CGPointMake(37.8, 28), controlPoint1: CGPointMake(39.38, 28.32), controlPoint2: CGPointMake(39.01, 28))
    path.moveToPoint(CGPointMake(37.8, 28))
    return path
  }
  
  static var playBar2Path: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(49.02, 34.61))
    path.addLineToPoint(CGPointMake(49.02, 40.86))
    path.addLineToPoint(CGPointMake(49.02, 49.21))
    path.addLineToPoint(CGPointMake(49.02, 55.15))
    path.addLineToPoint(CGPointMake(60.54, 47.57))
    path.addLineToPoint(CGPointMake(61.99, 46.63))
    path.addCurveToPoint(CGPointMake(62.02, 43.09), controlPoint1: CGPointMake(63.52, 45.54), controlPoint2: CGPointMake(63.52, 44.12))
    path.addLineToPoint(CGPointMake(60.54, 42.1))
    path.addLineToPoint(CGPointMake(49.02, 34.61))
    return path
  }
}
