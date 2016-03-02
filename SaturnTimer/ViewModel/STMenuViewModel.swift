//
//  STMenuViewModel.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import QorumLogs
import AVFoundation

class STMenuViewModel: STViewModel {
  
  //Output
  let tagType = MutableProperty<STTagType>(.SaturnType)
  let soundFileName = MutableProperty<String>(UILocalNotificationDefaultSoundName)
  let soundFileNameArray = MutableProperty<[String]>([])
  
  //Action
  lazy var changeTagAction: Action<STTagType, STTagType, NoError> = {
    return Action({[weak self] type in
      guard let _self = self else {return SignalProducer(value: STTagType.SaturnType)}
      
      _self.tagType.value = type
      
      return SignalProducer(value: _self.tagType.value)
    })
  }()
  
  lazy var changeSoundFileNameAction: Action<String, String, NoError> = {
    return Action({[weak self] fileName in
      guard let _self = self else {return SignalProducer(value: UILocalNotificationDefaultSoundName)}
      
      _self.soundFileName.value = fileName
      
      return SignalProducer(value: _self.soundFileName.value)
    })
  }()
  
  //Private
  
  var audioPlayer: AVAudioPlayer?
  
  //Lifecircle

  override init() {
    if let soundsPlistPath = NSBundle.mainBundle().pathForResource("Sounds", ofType: "plist") {
      if let sounds = NSArray(contentsOfFile: soundsPlistPath) as? [String] {
        soundFileNameArray.value = sounds
      }
    }
  }
  
  func playSoundWithFileName (fileName: String) {
    do {
      let fileNameComponents = fileName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
      if fileNameComponents.count > 1 {
        if let url = NSBundle.mainBundle().URLForResource(fileNameComponents[0], withExtension: fileNameComponents[1]) {
          audioPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: fileNameComponents[1])
          audioPlayer?.play()
        }
      }
    }
    catch {
      QL1(error)
    }
  }
  
  func stopPlayingSound () {
    audioPlayer?.stop()
    audioPlayer = nil
  }
  
  //Data Source
  func numberOfSections() -> Int {
    return 1
  }
  
  func numberOfSoundsInSection(section: Int) -> Int {
    return soundFileNameArray.value.count
  }
  
  func soundNameAtIndexPath(indexPath: NSIndexPath) -> NSAttributedString {
    let soundFileName = soundFileNameArray.value[indexPath.row]
    let soundName = soundFileName.stringByReplacingOccurrencesOfString(".mp3", withString: "")
    let isSurrentSoundFileName = self.soundFileName.value == soundFileName
    let attributes = [
      NSForegroundColorAttributeName: isSurrentSoundFileName ? HelperColor.primaryColor : HelperColor.lightGrayColor
    ]
    let sound = NSAttributedString(string: soundName, attributes: attributes)
    return sound
  }
  
  //Sound Selection
  
  func selectSoundAtIndexPath(indexPath: NSIndexPath) {
    let soundFileName = soundFileNameArray.value[indexPath.row]
    stopPlayingSound()
    playSoundWithFileName(soundFileName)
    self.soundFileName.value = soundFileName
  }
}
