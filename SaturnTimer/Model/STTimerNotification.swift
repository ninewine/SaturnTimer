//
//  STTimerNotification.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 3/10/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import AVFoundation

class STTimerNotification: NSObject {
  internal class var shareInstance: STTimerNotification {
    struct Static {
      static let instance: STTimerNotification = STTimerNotification()
    }
    return Static.instance
  }

  var audioPlayer: AVAudioPlayer?

  func showNotificationWithLocalNotification(notification: UILocalNotification) {
    showNotification(notification.alertBody)
    playSoundWithNotification(notification)
  }
  
  func showNotificationWithString (alertBody: String?) {
    showNotification(alertBody)
  }
  
  func playSoundWithFileName (fileName: String) {
    let soundFileComponents = fileName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
    if soundFileComponents.count > 1 {
      if let url = NSBundle.mainBundle().URLForResource(soundFileComponents[0], withExtension: soundFileComponents[1]) {
        do {
          audioPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: soundFileComponents[1])
          audioPlayer?.play()
        }
        catch {
        }
      }
    }
  }
  
  private func showNotification (alertBody: String?) {
    let alert = RCAlertView(title: nil, message: alertBody, image: nil)
    
    alert.addButtonWithTitle(HelperLocalization.Done, type: .Fill, handler: {[weak self] _ in
      self?.audioPlayer?.stop()
      })
    alert.show()
  }
  
  private func playSoundWithNotification (notification: UILocalNotification) {
    if let fireDate = notification.fireDate {
      if NSDate().timeIntervalSinceDate(fireDate) < 0.5 {
        if let soundFileName = notification.soundName where soundFileName != UILocalNotificationDefaultSoundName {
          playSoundWithFileName(soundFileName)
        }
      }
    }
  }
}
