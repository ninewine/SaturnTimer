//
//  Array+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/28/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import Foundation

extension CollectionType where Index == Int {
	func shuffle() -> [Generator.Element] {
		var list = Array(self)
		list.shuffleInPlace()
		return list
	}
}

extension MutableCollectionType where Index == Int {
	mutating func shuffleInPlace() {
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
