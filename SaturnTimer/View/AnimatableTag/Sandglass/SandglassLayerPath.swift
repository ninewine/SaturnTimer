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
		path.move(to: CGPoint(x: 1.5, y: 1.5))
		path.addLine(to: CGPoint(x: 18.5, y: 1.5))
		return path
	}
	
	static var topGlassPath: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4, y: 2))
		path.addLine(to: CGPoint(x: 4, y: 8.27))
		path.addCurve(to: CGPoint(x: 10, y: 14.27), controlPoint1: CGPoint(x: 4, y: 11.58), controlPoint2: CGPoint(x: 6.69, y: 14.27))
		path.addCurve(to: CGPoint(x: 16, y: 8.27), controlPoint1: CGPoint(x: 13.31, y: 14.27), controlPoint2: CGPoint(x: 16, y: 11.58))
		path.addLine(to: CGPoint(x: 16, y: 2.03))
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var basePath: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 1.5, y: 27.5))
		path.addLine(to: CGPoint(x: 18.5, y: 27.5))
		return path
	}
	
	static var baseGlassPath: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4, y: 27))
		path.addLine(to: CGPoint(x: 4, y: 20.73))
		path.addCurve(to: CGPoint(x: 10, y: 14.73), controlPoint1: CGPoint(x: 4, y: 17.42), controlPoint2: CGPoint(x: 6.69, y: 14.73))
		path.addCurve(to: CGPoint(x: 16, y: 20.73), controlPoint1: CGPoint(x: 13.31, y: 14.73), controlPoint2: CGPoint(x: 16, y: 17.42))
		path.addLine(to: CGPoint(x: 16, y: 26.97))
		path.usesEvenOddFillRule = true
		return path
	}
	
	//MARK: Sand
	static var sandTopLevel1Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4, y: 4))
		path.addLine(to: CGPoint(x: 4, y: 8.27))
		path.addCurve(to: CGPoint(x: 10, y: 14.27), controlPoint1: CGPoint(x: 4, y: 11.58), controlPoint2: CGPoint(x: 6.69, y: 14.27))
		path.addCurve(to: CGPoint(x: 16, y: 8.27), controlPoint1: CGPoint(x: 13.31, y: 14.27), controlPoint2: CGPoint(x: 16, y: 11.58))
		path.addLine(to: CGPoint(x: 16, y: 4))
		path.addLine(to: CGPoint(x: 4, y: 4))
		path.close()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel2Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4, y: 7.92))
		path.addLine(to: CGPoint(x: 4, y: 8.27))
		path.addCurve(to: CGPoint(x: 10, y: 14.27), controlPoint1: CGPoint(x: 4, y: 11.58), controlPoint2: CGPoint(x: 6.69, y: 14.27))
		path.addCurve(to: CGPoint(x: 16, y: 8.27), controlPoint1: CGPoint(x: 13.31, y: 14.27), controlPoint2: CGPoint(x: 16, y: 11.58))
		path.addLine(to: CGPoint(x: 16, y: 7.92))
		path.addLine(to: CGPoint(x: 4, y: 7.92))
		path.close()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel3Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4, y: 10.15))
		path.addLine(to: CGPoint(x: 4, y: 10.4))
		path.addCurve(to: CGPoint(x: 10, y: 14.27), controlPoint1: CGPoint(x: 4, y: 11.1), controlPoint2: CGPoint(x: 6.69, y: 14.27))
		path.addCurve(to: CGPoint(x: 16, y: 10.4), controlPoint1: CGPoint(x: 13.31, y: 14.27), controlPoint2: CGPoint(x: 16, y: 11.1))
		path.addLine(to: CGPoint(x: 16, y: 10.15))
		path.addLine(to: CGPoint(x: 4, y: 10.15))
		path.close()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel4Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 5.02, y: 11.64))
		path.addLine(to: CGPoint(x: 5.29, y: 12.21))
		path.addCurve(to: CGPoint(x: 10, y: 14.27), controlPoint1: CGPoint(x: 5.76, y: 12.76), controlPoint2: CGPoint(x: 6.69, y: 14.27))
		path.addCurve(to: CGPoint(x: 14.73, y: 12.21), controlPoint1: CGPoint(x: 13.31, y: 14.27), controlPoint2: CGPoint(x: 14.23, y: 12.91))
		path.addLine(to: CGPoint(x: 15.06, y: 11.64))
		path.addLine(to: CGPoint(x: 5.02, y: 11.64))
		path.close()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandTopLevel5Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 6.25, y: 12.96))
		path.addLine(to: CGPoint(x: 7.55, y: 13.71))
		path.addCurve(to: CGPoint(x: 10, y: 14.27), controlPoint1: CGPoint(x: 8.74, y: 14.34), controlPoint2: CGPoint(x: 9.43, y: 14.27))
		path.addCurve(to: CGPoint(x: 12.51, y: 13.71), controlPoint1: CGPoint(x: 10.57, y: 14.27), controlPoint2: CGPoint(x: 11.62, y: 14.27))
		path.addLine(to: CGPoint(x: 13.87, y: 12.96))
		path.addLine(to: CGPoint(x: 6.25, y: 12.96))
		path.close()
		path.usesEvenOddFillRule = true
		return path
	}
	
	static var sandBottomLevel1Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 8.38, y: 27))
		path.addLine(to: CGPoint(x: 9.98, y: 25.4))
		path.addLine(to: CGPoint(x: 11.61, y: 27.03))
		path.addLine(to: CGPoint(x: 11.61, y: 27.97))
		path.addLine(to: CGPoint(x: 8.38, y: 27.97))
		path.addLine(to: CGPoint(x: 8.38, y: 27))
		path.close()
		return path
	}
	
	static var sandBottomLevel2Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4.1, y: 27.02))
		path.addLine(to: CGPoint(x: 10.01, y: 21.11))
		path.addLine(to: CGPoint(x: 15.91, y: 27.02))
		path.addLine(to: CGPoint(x: 15.91, y: 27.47))
		path.addLine(to: CGPoint(x: 4.1, y: 27.47))
		path.addLine(to: CGPoint(x: 4.1, y: 27.02))
		path.close()
		return path
	}
	
	static var sandBottomLevel3Path: UIBezierPath {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 4.1, y: 24.02))
		path.addLine(to: CGPoint(x: 10.01, y: 18.11))
		path.addLine(to: CGPoint(x: 15.91, y: 24.02))
		path.addLine(to: CGPoint(x: 15.91, y: 27.47))
		path.addLine(to: CGPoint(x: 4.1, y: 27.47))
		path.addLine(to: CGPoint(x: 4.1, y: 24.02))
		path.close()
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
