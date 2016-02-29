//
//  STTagType.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/29/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

enum STTagType: String {
  case SaturnType = "saturn"
  case SandglassType = "sandglass"
  case TelevisionType = "television"
  case PlateType = "plate"
  
  func tagTypeTimeIsUpString () -> String {
    switch self {
    case .SaturnType: return HelperLocalization.timesupStringSaturnTag
    case .SandglassType: return HelperLocalization.timesupStringSandglassTag
    case .TelevisionType: return HelperLocalization.timesupStringTelevisionTag
    case .PlateType: return HelperLocalization.timesupStringPlateTag
    }
  }
  
  static func animatableTagClass (tagName: String) -> AnyClass? {
    if let type = STTagType(rawValue: tagName) {
      switch type {
      case .SaturnType: return Saturn.self
      case .SandglassType: return Sandglass.self
      case .TelevisionType: return Television.self
      case .PlateType: return Plate.self
      }
    }
    return nil
  }
}

