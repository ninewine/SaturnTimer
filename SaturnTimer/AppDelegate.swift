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
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var audioPlayer: AVAudioPlayer?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    #if DEBUG
      QorumLogs.enabled = true
    #endif
    
    if isFirstLaunch() {
      firstLaunchAction()
    }
  
    handleLaunchOptions(launchOptions)
    return true
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
  
  func playSoundWithNotification (notification: UILocalNotification) {
    if let fireDate = notification.fireDate {
      if NSDate().timeIntervalSinceDate(fireDate) < 0.5 {
        if let soundFileName = notification.soundName where soundFileName != UILocalNotificationDefaultSoundName {
          let soundFileComponents = soundFileName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
          if soundFileComponents.count > 1 {
            if let url = NSBundle.mainBundle().URLForResource(soundFileComponents[0], withExtension: soundFileComponents[1]) {
              do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: soundFileComponents[1])
                audioPlayer?.play()
              }
              catch {
                QL1(error)
              }
            }
          }
        }
      }
    }
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
    let alert = RCAlertView(title: nil, message: notification.alertBody, image: nil)
    
    alert.addButtonWithTitle(HelperLocalization.Done, type: .Fill, handler: {[weak self] _ in
      self?.audioPlayer?.stop()
    })
    alert.show()
    
    playSoundWithNotification(notification)
    
    QL1("Receive Local Notification: \(notification)")
    
    UIApplication.sharedApplication().cancelLocalNotification(notification)
  }
}

