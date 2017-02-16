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
    let path = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: 35, height: 35))
    return path
  }
  
  //square
  static var squarePath: UIBezierPath {
    let path = UIBezierPath(roundedRect: CGRect(x: 12.5, y: 12.5, width: 12, height: 12), cornerRadius: 0.6)
    return path
  }
  
  //cross
  static var crossPath: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 10, y: 19))
    path.addLine(to: CGPoint(x: 27.69, y: 19))
    return path
  }
  
  //arrow
  static var arrowTop: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 19))
    path.addLine(to: CGPoint(x: 10, y: 19))
    return path
  }
  
  static var arrowBottom: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 19))
    path.addLine(to: CGPoint(x: 10, y: 19))
    return path
  }
  //gear
  static var gearPath: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 26.44, y: 20.5))
    path.addLine(to: CGPoint(x: 25.12, y: 19.74))
    path.addCurve(to: CGPoint(x: 25.24, y: 18.5), controlPoint1: CGPoint(x: 25.2, y: 19.34), controlPoint2: CGPoint(x: 25.24, y: 18.92))
    path.addCurve(to: CGPoint(x: 25.12, y: 17.26), controlPoint1: CGPoint(x: 25.24, y: 18.08), controlPoint2: CGPoint(x: 25.2, y: 17.66))
    path.addLine(to: CGPoint(x: 26.44, y: 16.5))
    path.addCurve(to: CGPoint(x: 26.85, y: 14.95), controlPoint1: CGPoint(x: 26.98, y: 16.18), controlPoint2: CGPoint(x: 27.16, y: 15.49))
    path.addLine(to: CGPoint(x: 25.73, y: 12.99))
    path.addCurve(to: CGPoint(x: 24.19, y: 12.57), controlPoint1: CGPoint(x: 25.42, y: 12.44), controlPoint2: CGPoint(x: 24.73, y: 12.26))
    path.addLine(to: CGPoint(x: 22.86, y: 13.34))
    path.addCurve(to: CGPoint(x: 20.75, y: 12.09), controlPoint1: CGPoint(x: 22.24, y: 12.81), controlPoint2: CGPoint(x: 21.53, y: 12.38))
    path.addLine(to: CGPoint(x: 20.75, y: 11.13))
    path.addCurve(to: CGPoint(x: 19.62, y: 10), controlPoint1: CGPoint(x: 20.75, y: 10.51), controlPoint2: CGPoint(x: 20.24, y: 10))
    path.addLine(to: CGPoint(x: 17.38, y: 10))
    path.addCurve(to: CGPoint(x: 16.25, y: 11.13), controlPoint1: CGPoint(x: 16.76, y: 10), controlPoint2: CGPoint(x: 16.25, y: 10.51))
    path.addLine(to: CGPoint(x: 16.25, y: 12.09))
    path.addCurve(to: CGPoint(x: 14.14, y: 13.34), controlPoint1: CGPoint(x: 15.47, y: 12.38), controlPoint2: CGPoint(x: 14.76, y: 12.81))
    path.addLine(to: CGPoint(x: 12.81, y: 12.57))
    path.addCurve(to: CGPoint(x: 11.27, y: 12.99), controlPoint1: CGPoint(x: 12.27, y: 12.26), controlPoint2: CGPoint(x: 11.58, y: 12.44))
    path.addLine(to: CGPoint(x: 10.15, y: 14.95))
    path.addCurve(to: CGPoint(x: 10.56, y: 16.5), controlPoint1: CGPoint(x: 9.84, y: 15.49), controlPoint2: CGPoint(x: 10.02, y: 16.18))
    path.addLine(to: CGPoint(x: 11.88, y: 17.26))
    path.addCurve(to: CGPoint(x: 11.76, y: 18.5), controlPoint1: CGPoint(x: 11.8, y: 17.66), controlPoint2: CGPoint(x: 11.76, y: 18.08))
    path.addCurve(to: CGPoint(x: 11.88, y: 19.74), controlPoint1: CGPoint(x: 11.76, y: 18.92), controlPoint2: CGPoint(x: 11.8, y: 19.34))
    path.addLine(to: CGPoint(x: 10.56, y: 20.5))
    path.addCurve(to: CGPoint(x: 10.15, y: 22.05), controlPoint1: CGPoint(x: 10.02, y: 20.82), controlPoint2: CGPoint(x: 9.84, y: 21.51))
    path.addLine(to: CGPoint(x: 11.27, y: 24.01))
    path.addCurve(to: CGPoint(x: 12.81, y: 24.43), controlPoint1: CGPoint(x: 11.58, y: 24.56), controlPoint2: CGPoint(x: 12.27, y: 24.74))
    path.addLine(to: CGPoint(x: 14.14, y: 23.66))
    path.addCurve(to: CGPoint(x: 16.25, y: 24.91), controlPoint1: CGPoint(x: 14.76, y: 24.19), controlPoint2: CGPoint(x: 15.47, y: 24.63))
    path.addLine(to: CGPoint(x: 16.25, y: 25.87))
    path.addCurve(to: CGPoint(x: 17.38, y: 27), controlPoint1: CGPoint(x: 16.25, y: 26.49), controlPoint2: CGPoint(x: 16.76, y: 27))
    path.addLine(to: CGPoint(x: 19.62, y: 27))
    path.addCurve(to: CGPoint(x: 20.75, y: 25.87), controlPoint1: CGPoint(x: 20.24, y: 27), controlPoint2: CGPoint(x: 20.75, y: 26.49))
    path.addLine(to: CGPoint(x: 20.75, y: 24.91))
    path.addCurve(to: CGPoint(x: 22.86, y: 23.66), controlPoint1: CGPoint(x: 21.53, y: 24.63), controlPoint2: CGPoint(x: 22.24, y: 24.19))
    path.addLine(to: CGPoint(x: 24.19, y: 24.43))
    path.addCurve(to: CGPoint(x: 25.73, y: 24.01), controlPoint1: CGPoint(x: 24.73, y: 24.74), controlPoint2: CGPoint(x: 25.42, y: 24.56))
    path.addLine(to: CGPoint(x: 26.85, y: 22.05))
    path.addCurve(to: CGPoint(x: 26.44, y: 20.5), controlPoint1: CGPoint(x: 27.16, y: 21.51), controlPoint2: CGPoint(x: 26.98, y: 20.82))
    path.addLine(to: CGPoint(x: 26.44, y: 20.5))
    path.close()
    path.move(to: CGPoint(x: 18.5, y: 15.67))
    path.addCurve(to: CGPoint(x: 15.69, y: 18.5), controlPoint1: CGPoint(x: 16.95, y: 15.67), controlPoint2: CGPoint(x: 15.69, y: 16.93))
    path.addCurve(to: CGPoint(x: 18.5, y: 21.33), controlPoint1: CGPoint(x: 15.69, y: 20.07), controlPoint2: CGPoint(x: 16.95, y: 21.33))
    path.addCurve(to: CGPoint(x: 21.31, y: 18.5), controlPoint1: CGPoint(x: 20.05, y: 21.33), controlPoint2: CGPoint(x: 21.31, y: 20.07))
    path.addCurve(to: CGPoint(x: 18.5, y: 15.67), controlPoint1: CGPoint(x: 21.31, y: 16.93), controlPoint2: CGPoint(x: 20.05, y: 15.67))
    path.addLine(to: CGPoint(x: 18.5, y: 15.67))
    path.close()
    return path
  }
}
