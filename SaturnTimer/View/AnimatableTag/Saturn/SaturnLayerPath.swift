//
//  SaturnLayerPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/17/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct _SaturnLayerPath {
	
	static var planetPath: UIBezierPath {
		let path = UIBezierPath(ovalInRect: CGRectMake(3.8, 1.0, 24.1, 23.9))
		return path
	}
	
	static var ringPath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(2.66, 15.06))
		path.addCurveToPoint(CGPointMake(1.63, 16.98), controlPoint1: CGPointMake(1.82, 15.96), controlPoint2: CGPointMake(1.63, 16.17))
		path.addCurveToPoint(CGPointMake(2.88, 18.77), controlPoint1: CGPointMake(1.63, 17.78), controlPoint2: CGPointMake(2.36, 18.53))
		path.addCurveToPoint(CGPointMake(10.2, 19.56), controlPoint1: CGPointMake(3.4, 19.01), controlPoint2: CGPointMake(5.77, 20.09))
		path.addCurveToPoint(CGPointMake(21.11, 17.12), controlPoint1: CGPointMake(13.51, 19.26), controlPoint2: CGPointMake(16.76, 18.64))
		path.addCurveToPoint(CGPointMake(29.49, 12.34), controlPoint1: CGPointMake(25.18, 15.44), controlPoint2: CGPointMake(27.82, 14.21))
		path.addCurveToPoint(CGPointMake(30.55, 9.41), controlPoint1: CGPointMake(31.15, 10.46), controlPoint2: CGPointMake(30.71, 9.83))
		path.addCurveToPoint(CGPointMake(27.45, 7.88), controlPoint1: CGPointMake(30.25, 8.74), controlPoint2: CGPointMake(28.75, 7.59))
		return path
	}
	
	static var light1: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(18.26, 4.56))
		path.addCurveToPoint(CGPointMake(23.74, 8.79), controlPoint1: CGPointMake(20.93, 5.29), controlPoint2: CGPointMake(22.48, 6.74))
		return path
	}
	
	static var light2: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(24.56, 10.96))
		path.addCurveToPoint(CGPointMake(24.83, 12.39), controlPoint1: CGPointMake(24.71, 11.32), controlPoint2: CGPointMake(24.83, 11.78))
		return path
	}
	
	
}