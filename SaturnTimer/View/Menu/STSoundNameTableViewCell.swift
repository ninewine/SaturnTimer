//
//  STSoundNameTableViewCell.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/29/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit

class STSoundNameTableViewCell: UITableViewCell {
  @IBOutlet weak var soundNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.clear
  }
}
