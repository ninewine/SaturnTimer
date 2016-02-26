//
//  AnimatableTag.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 1/28/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa

class AnimatableTag: UIView {
	
	var _pausing = false

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init (frame: CGRect) {
		super.init(frame: frame)
		self.viewConfig()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.viewConfig()
	}
	
	func viewConfig () {
		self.registerNotification()
	}
	
	func registerNotification () {
		NSNotificationCenter
			.defaultCenter()
			.rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil)
			.takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.stopAnimation()
		}
		
		NSNotificationCenter
			.defaultCenter()
			.rac_addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil)
			.takeUntil(self.rac_willDeallocSignal()).subscribeNext {[weak self] (_) -> Void in
        self?.startAnimation()
		}
	}

	func startAnimation () {
		// for override
	}
	
	func stopAnimation () {
		// for override
	}
}
