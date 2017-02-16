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
    if let settings = UIApplication.shared.currentUserNotificationSettings {
      if settings.types.contains(.alert) && settings.types.contains(.sound) {
        return true
      }
    }
    return false
  }
  
  static func checkAccessibility (_ completion: ((_ granted: Bool, _ ignore: Bool) -> Void)?) {
    if self.isAccessible() {
      completion?(true, false)
    }
    else {
      let alert = RCAlertView(title: nil, message: HelperLocalization.CheckNotificationPermissionFailed, image: nil)
      alert.addButtonWithTitle(HelperLocalization.Settings, type: RCAlertViewButtonType.fill, handler: { (_) -> Void in
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
          UIApplication.shared.openURL(url)
        }
        completion?(false, false)
      })
      alert.addButtonWithTitle(HelperLocalization.Ignore, type: RCAlertViewButtonType.cancel, handler: { (_) -> Void in
        UIApplication.shared.isIdleTimerDisabled = true
        completion?(false, true)
      })
      alert.show()
    }
  }
  
  static func askForPermission () {
    let asked = UserDefaults.standard.bool(forKey: HelperConstant.UserDefaultKey.AlreadyAskedForNotificationPermission)
    if asked {
      self.checkAccessibility(nil)
    }
    else {
      let alert = RCAlertView(title: nil, message: HelperLocalization.AskForNotificationPermission, image: UIImage(named: "pic-logo-without-text"))
      alert.addButtonWithTitle(HelperLocalization.OK, type: RCAlertViewButtonType.fill) { (_) -> Void in
        UserDefaults.standard.set(true, forKey: HelperConstant.UserDefaultKey.AlreadyAskedForNotificationPermission)
        let types:UIUserNotificationType = [.badge, .sound, .alert]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
      }
      alert.show()
    }
  }
}
