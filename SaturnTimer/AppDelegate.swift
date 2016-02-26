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
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    #if DEBUG
      QorumLogs.enabled = true
    #endif
    
    if isFirstLaunch() {
      firstLaunchAction()
    }
  
    return true
  }

  //MARK: - Action
  
  func isFirstLaunch () -> Bool {
    if let isFirstLauch = NSUserDefaults.standardUserDefaults().valueForKey(HelperConstant.UserDefaultKey.IsFirstLaunch) as? Bool {
      return isFirstLauch
    }
    else {
      return true
    }
  }
  
  func firstLaunchAction () {
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: HelperConstant.UserDefaultKey.IsFirstLaunch)
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
  
  
  //MARK: - Helper
  
  class func getAppDelegate () -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
  }

  //MARK: - Nofitication
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    QL1("Receive Local Notification: \(notification)")
    application.cancelLocalNotification(notification)
  }
  
  func handleNotification (launchOptions: [NSObject: AnyObject]?) {
    if let option = launchOptions {
      if let notification = option[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification{
        UIApplication.sharedApplication().cancelLocalNotification(notification)
      }
    }
  }
}

