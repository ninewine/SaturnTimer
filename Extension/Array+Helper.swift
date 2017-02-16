//
//  Array+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/28/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import Foundation

extension MutableCollection where Indices.Iterator.Element == Index {

  mutating func shuffle() {
    let c = count
    guard c > 1 else { return }
    
    for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
      let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
      guard d != 0 else { continue }
      let i = index(firstUnshuffled, offsetBy: d)
      swap(&self[firstUnshuffled], &self[i])
    }
  }
}

extension Sequence {

  func shuffled() -> [Iterator.Element] {
    var result = Array(self)
    result.shuffle()
    return result
  }
}

extension Array where Element: Equatable {
  @discardableResult
	mutating func remove (_ object: Iterator.Element) -> Bool {
		if let idx = self.index(of: object) {
			self.remove(at: idx)
			return true
		}
		return false
	}
}
