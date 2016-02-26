//
//  SandglassLayerPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

//MARK: - _GlassPath

import UIKit

struct _GlassLayerPath {
	//MARK: - Glass
	static var topPath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(1.5, 1.5))
		path.addLineToPoint(CGPointMake(18.5, 1.5))
		return path
	}
	
	static var topGlassPath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4, 2))
		path.addLineToPoint(CGPointMake(4, 8.27))
		path.addCurveToPoint(CGPointMake(10, 14.27), controlPoint1: CGPointMake(4, 11.58), controlPoint2: CGPointMake(6.69, 14.27))
		path.addCurveToPoint(CGPointMake(16, 8.27), controlPoint1: CGPointMake(13.31, 14.27), controlPoint2: CGPointMake(16, 11.58))
		path.addLineToPoint(CGPointMake(16, 2.03))
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var basePath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(1.5, 27.5))
		path.addLineToPoint(CGPointMake(18.5, 27.5))
		return path
	}
	
	static var baseGlassPath: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4, 27))
		path.addLineToPoint(CGPointMake(4, 20.73))
		path.addCurveToPoint(CGPointMake(10, 14.73), controlPoint1: CGPointMake(4, 17.42), controlPoint2: CGPointMake(6.69, 14.73))
		path.addCurveToPoint(CGPointMake(16, 20.73), controlPoint1: CGPointMake(13.31, 14.73), controlPoint2: CGPointMake(16, 17.42))
		path.addLineToPoint(CGPointMake(16, 26.97))
		path.usesEvenOddFillRule = true
		return path
	}
	
	//MARK: Sand
	static var sandTopLevel1Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4, 4))
		path.addLineToPoint(CGPointMake(4, 8.27))
		path.addCurveToPoint(CGPointMake(10, 14.27), controlPoint1: CGPointMake(4, 11.58), controlPoint2: CGPointMake(6.69, 14.27))
		path.addCurveToPoint(CGPointMake(16, 8.27), controlPoint1: CGPointMake(13.31, 14.27), controlPoint2: CGPointMake(16, 11.58))
		path.addLineToPoint(CGPointMake(16, 4))
		path.addLineToPoint(CGPointMake(4, 4))
		path.closePath()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel2Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4, 7.92))
		path.addLineToPoint(CGPointMake(4, 8.27))
		path.addCurveToPoint(CGPointMake(10, 14.27), controlPoint1: CGPointMake(4, 11.58), controlPoint2: CGPointMake(6.69, 14.27))
		path.addCurveToPoint(CGPointMake(16, 8.27), controlPoint1: CGPointMake(13.31, 14.27), controlPoint2: CGPointMake(16, 11.58))
		path.addLineToPoint(CGPointMake(16, 7.92))
		path.addLineToPoint(CGPointMake(4, 7.92))
		path.closePath()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel3Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4, 10.15))
		path.addLineToPoint(CGPointMake(4, 10.4))
		path.addCurveToPoint(CGPointMake(10, 14.27), controlPoint1: CGPointMake(4, 11.1), controlPoint2: CGPointMake(6.69, 14.27))
		path.addCurveToPoint(CGPointMake(16, 10.4), controlPoint1: CGPointMake(13.31, 14.27), controlPoint2: CGPointMake(16, 11.1))
		path.addLineToPoint(CGPointMake(16, 10.15))
		path.addLineToPoint(CGPointMake(4, 10.15))
		path.closePath()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel4Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(5.02, 11.64))
		path.addLineToPoint(CGPointMake(5.29, 12.21))
		path.addCurveToPoint(CGPointMake(10, 14.27), controlPoint1: CGPointMake(5.76, 12.76), controlPoint2: CGPointMake(6.69, 14.27))
		path.addCurveToPoint(CGPointMake(14.73, 12.21), controlPoint1: CGPointMake(13.31, 14.27), controlPoint2: CGPointMake(14.23, 12.91))
		path.addLineToPoint(CGPointMake(15.06, 11.64))
		path.addLineToPoint(CGPointMake(5.02, 11.64))
		path.closePath()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel5Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(6.25, 12.96))
		path.addLineToPoint(CGPointMake(7.55, 13.71))
		path.addCurveToPoint(CGPointMake(10, 14.27), controlPoint1: CGPointMake(8.74, 14.34), controlPoint2: CGPointMake(9.43, 14.27))
		path.addCurveToPoint(CGPointMake(12.51, 13.71), controlPoint1: CGPointMake(10.57, 14.27), controlPoint2: CGPointMake(11.62, 14.27))
		path.addLineToPoint(CGPointMake(13.87, 12.96))
		path.addLineToPoint(CGPointMake(6.25, 12.96))
		path.closePath()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandBottomLevel1Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(8.38, 27))
		path.addLineToPoint(CGPointMake(9.98, 25.4))
		path.addLineToPoint(CGPointMake(11.61, 27.03))
		path.addLineToPoint(CGPointMake(11.61, 27.97))
		path.addLineToPoint(CGPointMake(8.38, 27.97))
		path.addLineToPoint(CGPointMake(8.38, 27))
		path.closePath()
		return path
	}
	
	static var sandBottomLevel2Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4.1, 27.02))
		path.addLineToPoint(CGPointMake(10.01, 21.11))
		path.addLineToPoint(CGPointMake(15.91, 27.02))
		path.addLineToPoint(CGPointMake(15.91, 27.47))
		path.addLineToPoint(CGPointMake(4.1, 27.47))
		path.addLineToPoint(CGPointMake(4.1, 27.02))
		path.closePath()
		return path
	}
	
	static var sandBottomLevel3Path: UIBezierPath {
		let path = UIBezierPath()
		path.moveToPoint(CGPointMake(4.1, 24.02))
		path.addLineToPoint(CGPointMake(10.01, 18.11))
		path.addLineToPoint(CGPointMake(15.91, 24.02))
		path.addLineToPoint(CGPointMake(15.91, 27.47))
		path.addLineToPoint(CGPointMake(4.1, 27.47))
		path.addLineToPoint(CGPointMake(4.1, 24.02))
		path.closePath()
		return path
	}
	
	static var sandPathsTop: [UIBezierPath] {
		return [
			self.sandTopLevel1Path,
			self.sandTopLevel2Path,
			self.sandTopLevel3Path,
			self.sandTopLevel4Path,
			self.sandTopLevel5Path
		]
	}
	
	static var sandPathsBottom: [UIBezierPath] {
		return [
			self.sandBottomLevel1Path,
			self.sandBottomLevel2Path,
			self.sandBottomLevel3Path
		]
	}
}