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
    let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 90, height: 90))
    return path
  }
  
  static var pauseBar1Path: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 35.8, y: 29))
    path.addCurve(to: CGPoint(x: 33.5, y: 31.29), controlPoint1: CGPoint(x: 34.53, y: 29), controlPoint2: CGPoint(x: 33.5, y: 30.02))
    path.addLine(to: CGPoint(x: 33.5, y: 58.71))
    path.addCurve(to: CGPoint(x: 35.8, y: 61), controlPoint1: CGPoint(x: 33.5, y: 59.98), controlPoint2: CGPoint(x: 34.53, y: 61))
    path.addLine(to: CGPoint(x: 40.4, y: 61))
    path.addCurve(to: CGPoint(x: 42.7, y: 58.71), controlPoint1: CGPoint(x: 41.67, y: 61), controlPoint2: CGPoint(x: 42.7, y: 59.98))
    path.addLine(to: CGPoint(x: 42.7, y: 31.29))
    path.addCurve(to: CGPoint(x: 40.4, y: 29), controlPoint1: CGPoint(x: 42.7, y: 30.02), controlPoint2: CGPoint(x: 41.67, y: 29))
    path.move(to: CGPoint(x: 35.8, y: 29))
    return path
  }
  
  static var pauseBar2Path: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 49.3, y: 29))
    path.addCurve(to: CGPoint(x: 47, y: 31.29), controlPoint1: CGPoint(x: 48.03, y: 29), controlPoint2: CGPoint(x: 47, y: 30.02))
    path.addLine(to: CGPoint(x: 47, y: 58.71))
    path.addCurve(to: CGPoint(x: 49.3, y: 61), controlPoint1: CGPoint(x: 47, y: 59.98), controlPoint2: CGPoint(x: 48.03, y: 61))
    path.addLine(to: CGPoint(x: 53.9, y: 61))
    path.addCurve(to: CGPoint(x: 56.2, y: 58.71), controlPoint1: CGPoint(x: 55.17, y: 61), controlPoint2: CGPoint(x: 56.2, y: 59.98))
    path.addLine(to: CGPoint(x: 56.2, y: 31.29))
    path.addCurve(to: CGPoint(x: 53.9, y: 29), controlPoint1: CGPoint(x: 56.2, y: 30.02), controlPoint2: CGPoint(x: 55.17, y: 29))
    path.move(to: CGPoint(x: 49.3, y: 29))
    return path
  }
  
  static var playBar1Path: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 37.8, y: 28))
    path.addCurve(to: CGPoint(x: 36.5, y: 30.46), controlPoint1: CGPoint(x: 36.92, y: 28.32), controlPoint2: CGPoint(x: 36.5, y: 28.94))
    path.addLine(to: CGPoint(x: 36.5, y: 59.01))
    path.addCurve(to: CGPoint(x: 37.8, y: 61.65), controlPoint1: CGPoint(x: 36.5, y: 60.97), controlPoint2: CGPoint(x: 37.07, y: 61.5))
    path.addCurve(to: CGPoint(x: 39.98, y: 60.97), controlPoint1: CGPoint(x: 38.68, y: 62.05), controlPoint2: CGPoint(x: 39.98, y: 60.97))
    path.addLine(to: CGPoint(x: 49.5, y: 54.82))
    path.addLine(to: CGPoint(x: 49.5, y: 34.93))
    path.addCurve(to: CGPoint(x: 39.98, y: 28.69), controlPoint1: CGPoint(x: 49.5, y: 34.93), controlPoint2: CGPoint(x: 40.68, y: 29.22))
    path.addCurve(to: CGPoint(x: 37.8, y: 28), controlPoint1: CGPoint(x: 39.38, y: 28.32), controlPoint2: CGPoint(x: 39.01, y: 28))
    path.move(to: CGPoint(x: 37.8, y: 28))
    return path
  }
  
  static var playBar2Path: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 49.02, y: 34.61))
    path.addLine(to: CGPoint(x: 49.02, y: 40.86))
    path.addLine(to: CGPoint(x: 49.02, y: 49.21))
    path.addLine(to: CGPoint(x: 49.02, y: 55.15))
    path.addLine(to: CGPoint(x: 60.54, y: 47.57))
    path.addLine(to: CGPoint(x: 61.99, y: 46.63))
    path.addCurve(to: CGPoint(x: 62.02, y: 43.09), controlPoint1: CGPoint(x: 63.52, y: 45.54), controlPoint2: CGPoint(x: 63.52, y: 44.12))
    path.addLine(to: CGPoint(x: 60.54, y: 42.1))
    path.addLine(to: CGPoint(x: 49.02, y: 34.61))
    return path
  }
}
