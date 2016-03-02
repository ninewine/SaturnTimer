//
//  HelperCommon.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/29/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

enum DeviceType: Int {
  case iPhone4, iPhone5, iPhone6, iPhone6Plus, iPad
}

struct HelperCommon {
  static var currentDeviceType: DeviceType {
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
      return .iPad
    }
    else {
      let screenBounds = UIScreen.mainScreen().bounds
      if screenBounds.size.height < 568.0 {
        return .iPhone4
      }
      else if screenBounds.size.height == 568.0 {
        return .iPhone5
      }
      else if screenBounds.size.height == 667.0 {
        return .iPhone6
      }
      else {
        return .iPhone6Plus
      }
    }
  }
  
  static func randomNumberBetween(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max-min+1))) + min
  }

}
