//
//  HightlightableProtocol.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/26/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

public protocol HighlightableProtocol {
  
  func setHighlightStatus (_ highlighted: Bool, animated: Bool)
  func layersNeedToBeHighlighted () -> [CAShapeLayer]?
  
}
