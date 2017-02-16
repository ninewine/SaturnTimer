//
//  NSObject+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

extension NSObject {
  class func classString() -> String {
    let className: String = NSStringFromClass(self)
    let dotRange = className.range(of: ".")
    if (dotRange != nil) {
      let rangeNeedToBeRemoved: Range<String.Index> = (className.startIndex ..< dotRange!.upperBound)
      return className.replacingCharacters(in: rangeNeedToBeRemoved, with:"")
    }
    return ""
  }
  
  class func fullClassString() -> String {
    return NSStringFromClass(self)
  }
}
