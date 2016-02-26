//
//  HelperLocalization.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/24/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

struct HelperLocalization {
  
  static let AskForNotificationPermission: String = HelperLocalization.string(key: "AskForNotificationPermission")
  static let CheckNotificationPermissionFailed: String = HelperLocalization.string(key: "CheckNotificationPermissionFailed")
  
  static let Done: String = HelperLocalization.string(key: "Done")
  static let Close: String = HelperLocalization.string(key: "Close")
  static let Back: String = HelperLocalization.string(key: "Back")
  static let OK: String = HelperLocalization.string(key: "OK")
  static let Settings: String = HelperLocalization.string(key: "Settings")

  static func string (key key: String) -> String {
    return NSLocalizedString(key, comment: "")
  }
}
