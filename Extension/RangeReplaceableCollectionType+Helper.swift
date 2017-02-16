//
//  RangeReplaceableCollectionType+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 3/1/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//
//


extension RangeReplaceableCollection where Iterator.Element : Equatable {  
  mutating func remove(_ object : Iterator.Element) {
    if let index = self.index(of: object) {
      self.remove(at: index)
    }
  }
}
