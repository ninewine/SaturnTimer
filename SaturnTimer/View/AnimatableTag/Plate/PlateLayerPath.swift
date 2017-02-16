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
		path.move(to: CGPoint(x: 13.31, y: 3.59))
		path.addCurve(to: CGPoint(x: 1, y: 15.9), controlPoint1: CGPoint(x: 6.51, y: 3.59), controlPoint2: CGPoint(x: 1, y: 9.1))
		path.addLine(to: CGPoint(x: 25.62, y: 15.9))
		path.addCurve(to: CGPoint(x: 13.31, y: 3.59), controlPoint1: CGPoint(x: 25.62, y: 9.1), controlPoint2: CGPoint(x: 20.11, y: 3.59))
		path.close()
		return path
	}
	
	static var topHandle1Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 13, y: 0.3))
		path.addLine(to: CGPoint(x: 13, y: 2.95))
		return path
	}
	
	static var topHandle2Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 10.74, y: 0))
		path.addLine(to: CGPoint(x: 15.26, y: 0))
		return path
	}
	
	static var bottomPath: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 1, y: 18.75))
		path.addLine(to: CGPoint(x: 25.62, y: 18.75))
		return path
	}
}
