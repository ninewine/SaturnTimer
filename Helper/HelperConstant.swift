//
//  HelperConstant.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/22/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct HelperConstant {
  struct _UserDefaultKey {
    let IsFirstLaunch = "IsFirstLaunch"
    let AlreadyAskedForNotificationPermission = "AlreadyAskedForNotificationPermission"
  }
  
  struct _NotificationName {
    let RightBottomButtonPressedNotification = "SaturnTimer.RightBottomButtonPressed"
  }
  
  static let UserDefaultKey = _UserDefaultKey()
  static let NotificationName = _NotificationName()
}
