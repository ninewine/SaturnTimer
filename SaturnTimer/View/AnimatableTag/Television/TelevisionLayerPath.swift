//
//  TelevisionLayerPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/18/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct _TelevisionLayerPath {
	static var bodyPath: UIBezierPath {
		let path = UIBezierPath(roundedRect: CGRectMake(1, 7, 23, 17.13), cornerRadius: 3)
		return path
	}
	
	static var screenPath: UIBezierPath {
		let path = UIBezierPath(roundedRect: CGRectMake(4, 10, 10.28, 10.28), cornerRadius: 1)
		return path
	}
	
	static var antennaPath1: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(12, 6.56))
		path.addLineToPoint(CGPointMake(4, 1))
		return path
	}
	
	static var antennaPath2: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(0, 6.56))
		path.addLineToPoint(CGPointMake(8.32, 1))
		return path
	}
	
	static var switchPath: UIBezierPath {
		let path = UIBezierPath(ovalInRect: CGRectMake(18, 10, 2.94, 2.94))
		return path
	}
	
	static var speakerPath1: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(18, 18))
		path.addLineToPoint(CGPointMake(20.62, 18))
		return path
	}
	
	static var speakerPath2: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(18, 20))
		path.addLineToPoint(CGPointMake(20.62, 20))
		return path
	}
	
}
