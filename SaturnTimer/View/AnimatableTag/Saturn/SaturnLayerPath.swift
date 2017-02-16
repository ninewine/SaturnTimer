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
		let path = UIBezierPath(ovalIn: CGRect(x: 3.8, y: 1.0, width: 24.1, height: 23.9))
		return path
	}
	
	static var ringPath: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 2.66, y: 15.06))
		path.addCurve(to: CGPoint(x: 1.63, y: 16.98), controlPoint1: CGPoint(x: 1.82, y: 15.96), controlPoint2: CGPoint(x: 1.63, y: 16.17))
		path.addCurve(to: CGPoint(x: 2.88, y: 18.77), controlPoint1: CGPoint(x: 1.63, y: 17.78), controlPoint2: CGPoint(x: 2.36, y: 18.53))
		path.addCurve(to: CGPoint(x: 10.2, y: 19.56), controlPoint1: CGPoint(x: 3.4, y: 19.01), controlPoint2: CGPoint(x: 5.77, y: 20.09))
		path.addCurve(to: CGPoint(x: 21.11, y: 17.12), controlPoint1: CGPoint(x: 13.51, y: 19.26), controlPoint2: CGPoint(x: 16.76, y: 18.64))
		path.addCurve(to: CGPoint(x: 29.49, y: 12.34), controlPoint1: CGPoint(x: 25.18, y: 15.44), controlPoint2: CGPoint(x: 27.82, y: 14.21))
		path.addCurve(to: CGPoint(x: 30.55, y: 9.41), controlPoint1: CGPoint(x: 31.15, y: 10.46), controlPoint2: CGPoint(x: 30.71, y: 9.83))
		path.addCurve(to: CGPoint(x: 27.45, y: 7.88), controlPoint1: CGPoint(x: 30.25, y: 8.74), controlPoint2: CGPoint(x: 28.75, y: 7.59))
		return path
	}
	
	static var light1: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 18.26, y: 4.56))
		path.addCurve(to: CGPoint(x: 23.74, y: 8.79), controlPoint1: CGPoint(x: 20.93, y: 5.29), controlPoint2: CGPoint(x: 22.48, y: 6.74))
		return path
	}
	
	static var light2: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 24.56, y: 10.96))
		path.addCurve(to: CGPoint(x: 24.83, y: 12.39), controlPoint1: CGPoint(x: 24.71, y: 11.32), controlPoint2: CGPoint(x: 24.83, y: 11.78))
		return path
	}
	
	
}
