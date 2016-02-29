//
//  _ActionButtonLayerPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct _ActionButtonLayerPath {
  static var ringPath: UIBezierPath {
    let path = UIBezierPath(ovalInRect: CGRectMake(1, 1, 35, 35))
    return path
  }
  
  //square
  static var squarePath: UIBezierPath {
    let path = UIBezierPath(roundedRect: CGRectMake(12.5, 12.5, 12, 12), cornerRadius: 0.6)
    return path
  }
  
  //cross
  static var crossPath: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(10, 19))
    path.addLineToPoint(CGPointMake(27.69, 19))
    return path
  }
  
  //arrow
  static var arrowTop: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(0, 19))
    path.addLineToPoint(CGPointMake(10, 19))
    return path
  }
  
  static var arrowBottom: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(0, 19))
    path.addLineToPoint(CGPointMake(10, 19))
    return path
  }
  //gear
  static var gearPath: UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(26.44, 20.5))
    path.addLineToPoint(CGPointMake(25.12, 19.74))
    path.addCurveToPoint(CGPointMake(25.24, 18.5), controlPoint1: CGPointMake(25.2, 19.34), controlPoint2: CGPointMake(25.24, 18.92))
    path.addCurveToPoint(CGPointMake(25.12, 17.26), controlPoint1: CGPointMake(25.24, 18.08), controlPoint2: CGPointMake(25.2, 17.66))
    path.addLineToPoint(CGPointMake(26.44, 16.5))
    path.addCurveToPoint(CGPointMake(26.85, 14.95), controlPoint1: CGPointMake(26.98, 16.18), controlPoint2: CGPointMake(27.16, 15.49))
    path.addLineToPoint(CGPointMake(25.73, 12.99))
    path.addCurveToPoint(CGPointMake(24.19, 12.57), controlPoint1: CGPointMake(25.42, 12.44), controlPoint2: CGPointMake(24.73, 12.26))
    path.addLineToPoint(CGPointMake(22.86, 13.34))
    path.addCurveToPoint(CGPointMake(20.75, 12.09), controlPoint1: CGPointMake(22.24, 12.81), controlPoint2: CGPointMake(21.53, 12.38))
    path.addLineToPoint(CGPointMake(20.75, 11.13))
    path.addCurveToPoint(CGPointMake(19.62, 10), controlPoint1: CGPointMake(20.75, 10.51), controlPoint2: CGPointMake(20.24, 10))
    path.addLineToPoint(CGPointMake(17.38, 10))
    path.addCurveToPoint(CGPointMake(16.25, 11.13), controlPoint1: CGPointMake(16.76, 10), controlPoint2: CGPointMake(16.25, 10.51))
    path.addLineToPoint(CGPointMake(16.25, 12.09))
    path.addCurveToPoint(CGPointMake(14.14, 13.34), controlPoint1: CGPointMake(15.47, 12.38), controlPoint2: CGPointMake(14.76, 12.81))
    path.addLineToPoint(CGPointMake(12.81, 12.57))
    path.addCurveToPoint(CGPointMake(11.27, 12.99), controlPoint1: CGPointMake(12.27, 12.26), controlPoint2: CGPointMake(11.58, 12.44))
    path.addLineToPoint(CGPointMake(10.15, 14.95))
    path.addCurveToPoint(CGPointMake(10.56, 16.5), controlPoint1: CGPointMake(9.84, 15.49), controlPoint2: CGPointMake(10.02, 16.18))
    path.addLineToPoint(CGPointMake(11.88, 17.26))
    path.addCurveToPoint(CGPointMake(11.76, 18.5), controlPoint1: CGPointMake(11.8, 17.66), controlPoint2: CGPointMake(11.76, 18.08))
    path.addCurveToPoint(CGPointMake(11.88, 19.74), controlPoint1: CGPointMake(11.76, 18.92), controlPoint2: CGPointMake(11.8, 19.34))
    path.addLineToPoint(CGPointMake(10.56, 20.5))
    path.addCurveToPoint(CGPointMake(10.15, 22.05), controlPoint1: CGPointMake(10.02, 20.82), controlPoint2: CGPointMake(9.84, 21.51))
    path.addLineToPoint(CGPointMake(11.27, 24.01))
    path.addCurveToPoint(CGPointMake(12.81, 24.43), controlPoint1: CGPointMake(11.58, 24.56), controlPoint2: CGPointMake(12.27, 24.74))
    path.addLineToPoint(CGPointMake(14.14, 23.66))
    path.addCurveToPoint(CGPointMake(16.25, 24.91), controlPoint1: CGPointMake(14.76, 24.19), controlPoint2: CGPointMake(15.47, 24.63))
    path.addLineToPoint(CGPointMake(16.25, 25.87))
    path.addCurveToPoint(CGPointMake(17.38, 27), controlPoint1: CGPointMake(16.25, 26.49), controlPoint2: CGPointMake(16.76, 27))
    path.addLineToPoint(CGPointMake(19.62, 27))
    path.addCurveToPoint(CGPointMake(20.75, 25.87), controlPoint1: CGPointMake(20.24, 27), controlPoint2: CGPointMake(20.75, 26.49))
    path.addLineToPoint(CGPointMake(20.75, 24.91))
    path.addCurveToPoint(CGPointMake(22.86, 23.66), controlPoint1: CGPointMake(21.53, 24.63), controlPoint2: CGPointMake(22.24, 24.19))
    path.addLineToPoint(CGPointMake(24.19, 24.43))
    path.addCurveToPoint(CGPointMake(25.73, 24.01), controlPoint1: CGPointMake(24.73, 24.74), controlPoint2: CGPointMake(25.42, 24.56))
    path.addLineToPoint(CGPointMake(26.85, 22.05))
    path.addCurveToPoint(CGPointMake(26.44, 20.5), controlPoint1: CGPointMake(27.16, 21.51), controlPoint2: CGPointMake(26.98, 20.82))
    path.addLineToPoint(CGPointMake(26.44, 20.5))
    path.closePath()
    path.moveToPoint(CGPointMake(18.5, 15.67))
    path.addCurveToPoint(CGPointMake(15.69, 18.5), controlPoint1: CGPointMake(16.95, 15.67), controlPoint2: CGPointMake(15.69, 16.93))
    path.addCurveToPoint(CGPointMake(18.5, 21.33), controlPoint1: CGPointMake(15.69, 20.07), controlPoint2: CGPointMake(16.95, 21.33))
    path.addCurveToPoint(CGPointMake(21.31, 18.5), controlPoint1: CGPointMake(20.05, 21.33), controlPoint2: CGPointMake(21.31, 20.07))
    path.addCurveToPoint(CGPointMake(18.5, 15.67), controlPoint1: CGPointMake(21.31, 16.93), controlPoint2: CGPointMake(20.05, 15.67))
    path.addLineToPoint(CGPointMake(18.5, 15.67))
    path.closePath()
    return path
  }
}
