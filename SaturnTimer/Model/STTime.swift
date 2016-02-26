//
//  STTime.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/23/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

struct STTime {
  var hour: Int
  var minute: Int
  var second: Int

  init(hour: Int, minute: Int, second: Int) {
    self.hour = hour
    self.minute = minute
    self.second = second
  }
  
  func isValid () -> Bool {
    if (hour > 0 || minute > 0 || second > 0) &&
      (hour <= 12 && minute <= 60 && second <= 60) {
      return true
    }
    return false
  }
}
