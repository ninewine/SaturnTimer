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
    let CurrentTagTypeName = "CurrentTagTypeName"
    let CurrentSoundFileName = "CurrentSoundFileName"
  }
  
  struct _UserDefaultValue {
    let DefaultSoundFileName = "Firefly.mp3"
  }
  
  struct _NotificationName {
    let RightBottomButtonPressedNotification = "SaturnTimer.RightBottomButtonPressed"
    let TagTypeChangedNotification = "SaturnTimer.TagTypeChanged"
  }
  
  struct _UmengReference {
    let AppKey = "56d56c1967e58e97e7001e8c"
  }
  
  static let UserDefaultKey = _UserDefaultKey()
  static let UserDefaultValue = _UserDefaultValue()
  static let NotificationName = _NotificationName()
  static let UmengReference = _UmengReference()

}
