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
  
    configUmeng()
    handleLaunchOptions(launchOptions)
    return true
  }

  func configUmeng () {
    MobClick.startWithAppkey(HelperConstant.UmengReference.AppKey, reportPolicy: BATCH, channelId: nil)
  }
  
  func handleLaunchOptions (launchOptions: [NSObject: AnyObject]?) {
    if let option = launchOptions {
      if let notification = option[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification{
        receivedLocalNotification(notification)
      }
    }
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
    NSUserDefaults
      .standardUserDefaults()
      .setBool(false,
        forKey: HelperConstant.UserDefaultKey.IsFirstLaunch)
    
    NSUserDefaults
      .standardUserDefaults()
      .setValue(STTagType.SaturnType.rawValue,
        forKey: HelperConstant.UserDefaultKey.CurrentTagTypeName)
    
    NSUserDefaults
      .standardUserDefaults()
      .setValue(HelperConstant.UserDefaultValue.DefaultSoundFileName,
        forKey: HelperConstant.UserDefaultKey.CurrentSoundFileName)
    
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
  
  //MARK: - Helper
  
  class func getAppDelegate () -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
  }

  //MARK: - Nofitication
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    receivedLocalNotification(notification)
  }

  func receivedLocalNotification (notification: UILocalNotification) {
    STTimerNotification.shareInstance.showNotificationWithLocalNotification(notification)
    UIApplication.sharedApplication().cancelLocalNotification(notification)
  }
}

