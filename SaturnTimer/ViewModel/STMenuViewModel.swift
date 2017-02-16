//
//  STMenuViewModel.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
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
    if let soundsPlistPath = Bundle.main.path(forResource: "Sounds", ofType: "plist") {
      if let sounds = NSArray(contentsOfFile: soundsPlistPath) as? [String] {
        soundFileNameArray.value = sounds
      }
    }
  }
  
  func playSoundWithFileName (_ fileName: String) {
    do {
      let fileNameComponents = fileName.components(separatedBy: CharacterSet(charactersIn: "."))
      if fileNameComponents.count > 1 {
        if let url = Bundle.main.url(forResource: fileNameComponents[0], withExtension: fileNameComponents[1]) {
          audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: fileNameComponents[1])
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
  
  func numberOfSoundsInSection(_ section: Int) -> Int {
    return soundFileNameArray.value.count
  }
  
  func soundNameAtIndexPath(_ indexPath: IndexPath) -> NSAttributedString {
    let soundFileName = soundFileNameArray.value[indexPath.row]
    let soundName = soundFileName.replacingOccurrences(of: ".mp3", with: "")
    let isSurrentSoundFileName = self.soundFileName.value == soundFileName
    let attributes = [
      NSForegroundColorAttributeName: isSurrentSoundFileName ? HelperColor.primaryColor : HelperColor.lightGrayColor
    ]
    let sound = NSAttributedString(string: soundName, attributes: attributes)
    return sound
  }
  
  //Sound Selection
  
  func selectSoundAtIndexPath(_ indexPath: IndexPath) {
    let soundFileName = soundFileNameArray.value[indexPath.row]
    stopPlayingSound()
    playSoundWithFileName(soundFileName)
    self.soundFileName.value = soundFileName
  }
}
