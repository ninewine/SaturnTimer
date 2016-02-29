//
//  Array+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/28/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import Foundation

extension CollectionType where Index == Int {
	/// Return a copy of `self` with its elements shuffled
	func shuffle() -> [Generator.Element] {
		var list = Array(self)
		list.shuffleInPlace()
		return list
	}
}

extension MutableCollectionType where Index == Int {
	/// Shuffle the elements of `self` in-place.
	mutating func shuffleInPlace() {
		// empty and single-element collections don't shuffle
		if count < 2 { return }
		
		for i in 0..<count - 1 {
			let j = Int(arc4random_uniform(UInt32(count - i))) + i
			if (i != j){
				swap(&self[i], &self[j])
			}
		}
	}
}

extension Array where Element: Equatable {
	mutating func removeObject (object: Generator.Element) -> Bool {
		if let idx = self.indexOf(object) {
			self.removeAtIndex(idx)
			return true
		}
		return false
	}
}