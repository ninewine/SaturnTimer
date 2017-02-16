//
//  STDialPlateLayerPath.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct _DialPlateLayerPath {
  static func ringPath (_ rect: CGRect) -> UIBezierPath {
    let path = UIBezierPath(ovalIn: rect)
    return path
  }
}
