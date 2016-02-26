//
//  HelperNotification.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/24/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct HelperNotification {
  static func checkNotificationAccessibility () -> Bool {
    if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
      if !(settings.types.contains(.Alert) && settings.types.contains(.Sound)) {
        let alert = RCAlertView(title: nil, message: HelperLocalization.CheckNotificationPermissionFailed, image: nil)
        alert.addButtonWithTitle(HelperLocalization.Settings, type: RCAlertViewButtonType.Fill, handler: { (_) -> Void in
          if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(url)
          }
        })
        alert.addButtonWithTitle(HelperLocalization.Close, type: RCAlertViewButtonType.Cancel, handler: nil)
        alert.show()
        return false
      }
    }
    return true
  }
  
  static func askForNotificationPermission () {
    let asked = NSUserDefaults.standardUserDefaults().boolForKey(HelperConstant.UserDefaultKey.AlreadyAskedForNotificationPermission)
    
    if asked {
      self.checkNotificationAccessibility()
    }
    else {
      let alert = RCAlertView(title: nil, message: HelperLocalization.AskForNotificationPermission, image: nil)
      alert.addButtonWithTitle(HelperLocalization.OK, type: RCAlertViewButtonType.Fill) { (_) -> Void in
        let types:UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
      }
      alert.show()
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: HelperConstant.UserDefaultKey.AlreadyAskedForNotificationPermission)
    }
  }
}
