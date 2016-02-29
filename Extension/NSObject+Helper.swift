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
    let dotRange = className.rangeOfString(".")
    if (dotRange != nil) {
      let rangeNeedToBeRemoved: Range<String.Index> = Range<String.Index>(start: className.startIndex, end:dotRange!.endIndex)
      return className.stringByReplacingCharactersInRange(rangeNeedToBeRemoved, withString:"")
    }
    return ""
  }
  
  class func fullClassString() -> String {
    return NSStringFromClass(self)
  }
}