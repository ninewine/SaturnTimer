//
//  CAShapeLayer+Swizzling.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

enum ShapeLayerColorType: Int {
  case stroke, fill
}

extension CAShapeLayer {
  fileprivate struct AssociatedKeys {
    static var ColorType = "ST_ColorType"
  }
  
  var colorType: ShapeLayerColorType? {
    get {
      if let typeInt = objc_getAssociatedObject(self, &AssociatedKeys.ColorType) as? Int {
        if let type = ShapeLayerColorType(rawValue: typeInt) {
          return type
        }
      }
      return nil
    }
    set {
      if let value = newValue {
        objc_setAssociatedObject(
          self,
          &AssociatedKeys.ColorType,
          value.rawValue,
          objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
      }
    }
  }
}
