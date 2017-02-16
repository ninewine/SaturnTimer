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
		let path = UIBezierPath(roundedRect: CGRect(x: 1, y: 7, width: 23, height: 17.13), cornerRadius: 3)
		return path
	}
	
	static var screenPath: UIBezierPath {
		let path = UIBezierPath(roundedRect: CGRect(x: 4, y: 10, width: 10.28, height: 10.28), cornerRadius: 1)
		return path
	}
	
	static var antennaPath1: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 12, y: 6.56))
		path.addLine(to: CGPoint(x: 4, y: 1))
		return path
	}
	
	static var antennaPath2: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 6.56))
		path.addLine(to: CGPoint(x: 8.32, y: 1))
		return path
	}
	
	static var switchPath: UIBezierPath {
		let path = UIBezierPath(ovalIn: CGRect(x: 18, y: 10, width: 2.94, height: 2.94))
		return path
	}
	
	static var speakerPath1: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 18, y: 18))
		path.addLine(to: CGPoint(x: 20.62, y: 18))
		return path
	}
	
	static var speakerPath2: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 18, y: 20))
		path.addLine(to: CGPoint(x: 20.62, y: 20))
		return path
	}
	
}
