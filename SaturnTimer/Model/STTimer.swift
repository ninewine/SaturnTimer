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
  dynamic var remainingTime: NSTimeInterval 
  
  private var innerTimer: NSTimer?
  
  init (remainingTime: NSTimeInterval) {
    self.remainingTime = remainingTime
  }
  
  func fire () {
    innerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("tikTok"), userInfo: nil, repeats: true)
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
  
  func tikTok () {
    if remainingTime > 0 {
      remainingTime--
    }
    else {
      invalidate()
    }
  }
}
