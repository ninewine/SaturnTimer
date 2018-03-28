//
//  STTimer.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/23/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class STTimer: NSObject {
  @objc dynamic var remainingTime: TimeInterval 
  
  fileprivate var innerTimer: Timer?
  
  init (remainingTime: TimeInterval) {
    self.remainingTime = remainingTime
  }
  
  func fire () {
    innerTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(STTimer.tikTok), userInfo: nil, repeats: true)
    tikTok()
  }
  
  func pause () {
    innerTimer?.invalidate()
    innerTimer = nil
  }
  
  func invalidate () {
    innerTimer?.invalidate()
    innerTimer = nil
  }
  
  @objc func tikTok () {
    if remainingTime > 0 {
      remainingTime -= 1
    }
    else {
      invalidate()
    }
  }
}
