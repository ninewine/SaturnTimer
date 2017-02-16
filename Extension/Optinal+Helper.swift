//
//  Optinal+Helper.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/18/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//


extension Optional {
	func withExtendedLifetime(_ body: (Wrapped) -> Void) {
		if let strongSelf = self {
			body(strongSelf)
		}
	}
}
