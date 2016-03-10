//
//  HelperNotification.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/24/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct HelperNotification {
  static func isAccessible () -> Bool {
    if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
      if settings.types.contains(.Alert) && settings.types.contains(.Sound) {
        return true
      }
    }
    return false
  }
  
  static func checkAccessibility (completion: ((granted: Bool, ignore: Bool) -> Void)?) {
    if self.isAccessible() {
      completion?(granted: true, ignore: false)
    }
    else {
      let alert = RCAlertView(title: nil, message: HelperLocalization.CheckNotificationPermissionFailed, image: nil)
      alert.addButtonWithTitle(HelperLocalization.Settings, type: RCAlertViewButtonType.Fill, handler: { (_) -> Void in
        if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
          UIApplication.sharedApplication().openURL(url)
        }
        completion?(granted: false, ignore: false)
      })
      alert.addButtonWithTitle(HelperLocalization.Ignore, type: RCAlertViewButtonType.Cancel, handler: { (_) -> Void in
        UIApplication.sharedApplication().idleTimerDisabled = true
        completion?(granted: false, ignore: true)
      })
      alert.show()
    }
  }
  
  static func askForPermission () {
    let asked = NSUserDefaults.standardUserDefaults().boolForKey(HelperConstant.UserDefaultKey.AlreadyAskedForNotificationPermission)
    
    if asked {
      self.checkAccessibility(nil)
    }
    else {
      let alert = RCAlertView(title: nil, message: HelperLocalization.AskForNotificationPermission, image: UIImage(named: "pic-logo-without-text"))
      alert.addButtonWithTitle(HelperLocalization.OK, type: RCAlertViewButtonType.Fill) { (_) -> Void in
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: HelperConstant.UserDefaultKey.AlreadyAskedForNotificationPermission)
        let types:UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
      }
      alert.show()
    }
  }
}
