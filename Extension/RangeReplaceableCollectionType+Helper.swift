//
//  RangeReplaceableCollectionType+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 3/1/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//
//


extension RangeReplaceableCollectionType where Generator.Element : Equatable {  
  mutating func removeObject(object : Generator.Element) {
    if let index = self.indexOf(object) {
      self.removeAtIndex(index)
    }
  }
}