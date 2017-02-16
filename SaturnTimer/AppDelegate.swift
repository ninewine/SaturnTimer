//
//  AppDelegate.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/19/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import SnapKit
import QorumLogs
import ReactiveCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    #if DEBUG
      QorumLogs.enabled = true
    #endif
    
    if isFirstLaunch() {
      firstLaunchAction()
    }
  
    configUmeng()
    handleLaunchOptions(launchOptions)
    return true
  }

  func configUmeng () {
    let config = UMAnalyticsConfig.sharedInstance()
    config?.appKey = HelperConstant.UmengReference.AppKey
    config?.ePolicy = BATCH
    MobClick.start(withConfigure: config)
  }
  
  func handleLaunchOptions (_ launchOptions: [AnyHashable: Any]?) {
    if let option = launchOptions {
      if let notification = option[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification{
        receivedLocalNotification(notification)
      }
    }
  }

  
  //MARK: - Action
  
  func isFirstLaunch () -> Bool {
    if let isFirstLauch = UserDefaults.standard.value(forKey: HelperConstant.UserDefaultKey.IsFirstLaunch) as? Bool {
      return isFirstLauch
    }
    else {
      return true
    }
  }
  
  func firstLaunchAction () {
    UserDefaults.standard
      .set(false,
        forKey: HelperConstant.UserDefaultKey.IsFirstLaunch)
    
    UserDefaults.standard
      .setValue(STTagType.SaturnType.rawValue,
        forKey: HelperConstant.UserDefaultKey.CurrentTagTypeName)
    
    UserDefaults.standard
      .setValue(HelperConstant.UserDefaultValue.DefaultSoundFileName,
        forKey: HelperConstant.UserDefaultKey.CurrentSoundFileName)
    
    UIApplication.shared.cancelAllLocalNotifications()
  }
  
  //MARK: - Helper
  
  class func getAppDelegate () -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }

  //MARK: - Nofitication
  
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    receivedLocalNotification(notification)
  }

  func receivedLocalNotification (_ notification: UILocalNotification) {
    STTimerNotification.shareInstance.showNotificationWithLocalNotification(notification)
    UIApplication.shared.cancelLocalNotification(notification)
  }
}

