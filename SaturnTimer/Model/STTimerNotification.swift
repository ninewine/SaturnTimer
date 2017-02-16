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

  func showNotificationWithLocalNotification(_ notification: UILocalNotification) {
    showNotification(notification.alertBody)
    playSoundWithNotification(notification)
  }
  
  func showNotificationWithString (_ alertBody: String?) {
    showNotification(alertBody)
  }
  
  func playSoundWithFileName (_ fileName: String) {
    let soundFileComponents = fileName.components(separatedBy: CharacterSet(charactersIn: "."))
    if soundFileComponents.count > 1 {
      if let url = Bundle.main.url(forResource: soundFileComponents[0], withExtension: soundFileComponents[1]) {
        do {
          audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: soundFileComponents[1])
          audioPlayer?.play()
        }
        catch {
        }
      }
    }
  }
  
  fileprivate func showNotification (_ alertBody: String?) {
    let alert = RCAlertView(title: nil, message: alertBody, image: nil)
    
    alert.addButtonWithTitle(HelperLocalization.Done, type: .fill, handler: {[weak self] _ in
      self?.audioPlayer?.stop()
      })
    alert.show()
  }
  
  fileprivate func playSoundWithNotification (_ notification: UILocalNotification) {
    if let fireDate = notification.fireDate {
      if Date().timeIntervalSince(fireDate) < 0.5 {
        if let soundFileName = notification.soundName, soundFileName != UILocalNotificationDefaultSoundName {
          playSoundWithFileName(soundFileName)
        }
      }
    }
  }
}
