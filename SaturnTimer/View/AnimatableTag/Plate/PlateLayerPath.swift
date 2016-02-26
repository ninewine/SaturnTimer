//
//  PlateLayerPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/18/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct _PlateLayerPath {
	static var topPath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(13.31, 3.59))
		path.addCurveToPoint(CGPointMake(1, 15.9), controlPoint1: CGPointMake(6.51, 3.59), controlPoint2: CGPointMake(1, 9.1))
		path.addLineToPoint(CGPointMake(25.62, 15.9))
		path.addCurveToPoint(CGPointMake(13.31, 3.59), controlPoint1: CGPointMake(25.62, 9.1), controlPoint2: CGPointMake(20.11, 3.59))
		path.closePath()
		return path
	}
	
	static var topHandle1Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(13, 0.3))
		path.addLineToPoint(CGPointMake(13, 2.95))
		return path
	}
	
	static var topHandle2Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(10.74, 0))
		path.addLineToPoint(CGPointMake(15.26, 0))
		return path
	}
	
	static var bottomPath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(1, 18.75))
		path.addLineToPoint(CGPointMake(25.62, 18.75))
		return path
	}
}
