//
//  STMenuViewController.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import pop

class STMenuViewController: STViewController, UITableViewDataSource, UITableViewDelegate {
  private var viewModel: STMenuViewModel = STMenuViewModel()

  weak var actionButton: STActionButton?
  
  @IBOutlet weak var saturn: Saturn!
  @IBOutlet weak var sandglass: Sandglass!
  @IBOutlet weak var television: Television!
  @IBOutlet weak var plate: Plate!
  
  @IBOutlet weak var layoutConstraintSettingsLeading: NSLayoutConstraint!
  @IBOutlet weak var layoutConstraintTopSettingsLabel: NSLayoutConstraint!
  @IBOutlet weak var layoutConstraintTopSoundsLabel: NSLayoutConstraint!
  
  @IBOutlet weak var soundNameLabel: UILabel!
  
  @IBOutlet weak var soundListTableView: UITableView!
  
  @IBOutlet weak var settingsPanelView: UIView!
  @IBOutlet weak var soundsPanelView: UIView!
  
  private var activeTagView: AnimatableTag?
  
  private var actionButtonDisposable: RACDisposable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    // Do any additional setup after loading the view.
  }
  
  func bindViewModelToHomeViewModel(viewModel: STHomeViewModel) {
    self.viewModel.tagType.value = viewModel.tagType.value
    self.viewModel.soundFileName.value = viewModel.soundFileName.value
    
    viewModel.tagType <~ self.viewModel.tagType
    viewModel.soundFileName <~ self.viewModel.soundFileName
    
    self.viewModel.soundFileName
      .producer
      .observeOn(UIScheduler())
      .map {$0.stringByReplacingOccurrencesOfString(".mp3", withString: "")}
      .startWithNext {[weak self] (soundName) -> () in
        self?.soundNameLabel.text = soundName
    }
    
  }
  
  func configView() {
    configTagView()
    
    if HelperCommon.currentDeviceType == .iPhone4 {
      layoutConstraintTopSettingsLabel.constant = 30
    }
    else if HelperCommon.currentDeviceType == .iPad {
      layoutConstraintTopSettingsLabel.constant = 150
      layoutConstraintTopSoundsLabel.constant = 150
    }
  }
  
  func configTagView() {
    if let tagTypeName = NSUserDefaults.standardUserDefaults().stringForKey(HelperConstant.UserDefaultKey.CurrentTagTypeName) {
      if let type = STTagType(rawValue: tagTypeName) {
        activateTag(type)
      }
    }
    
    saturn.rac_signalForControlEvents(.TouchUpInside).subscribeNext {[weak self] (btn) -> Void in
      self?.activateTag(.SaturnType)
    }
    
    sandglass.rac_signalForControlEvents(.TouchUpInside).subscribeNext {[weak self] (btn) -> Void in
      self?.activateTag(.SandglassType)
    }
    
    television.rac_signalForControlEvents(.TouchUpInside).subscribeNext {[weak self] (btn) -> Void in
      self?.activateTag(.TelevisionType)
    }
    
    plate.rac_signalForControlEvents(.TouchUpInside).subscribeNext {[weak self] (btn) -> Void in
      self?.activateTag(.PlateType)
    }
  }
  
  func configActionButton () {
    //subscribe for one open-close operation
    actionButtonDisposable = actionButton?
      .rac_signalForControlEvents(.TouchUpInside)
      .takeUntil(self.rac_willDeallocSignal())
      .subscribeNext({[weak self] (button) -> Void in
        if let btn = button as? STActionButton {
          btn.type = .Close
          self?.actionButtonDisposable?.dispose()
          self?.actionButtonDisposable = nil
          self?.hideSoundsList()
        }
    })
  }
  
  func activateTag(type: STTagType) {
    
    activeTagView?.setHighlightStatus(false, animated: true)
    
    switch type {
    case .SaturnType:
      saturn.setHighlightStatus(true, animated: true)
      activeTagView = saturn
      break
    case .SandglassType:
      sandglass.setHighlightStatus(true, animated: true)
      activeTagView = sandglass
      break
    case .TelevisionType:
      television.setHighlightStatus(true, animated: true)
      activeTagView = television
      break
    case .PlateType:
      plate.setHighlightStatus(true, animated: true)
      activeTagView = plate
      break
    }
    
    CocoaAction(viewModel.changeTagAction, { _ in return type }).execute(nil)
  }
  
  func showSoundsList () {
    moveSoundsList(true)
  }
  
  func hideSoundsList () {
    viewModel.audioPlayer?.stop()
    moveSoundsList(false)
  }
  
  func moveSoundsList (show: Bool) {
    let frame1 = settingsPanelView.frame
    let frameAnim1 = POPSpringAnimation(propertyNamed: kPOPViewFrame)

    frameAnim1.toValue =
      NSValue(CGRect:
        CGRect(
          x: show ? -frame1.width : 0,
          y: frame1.origin.y,
          width: frame1.width,
          height: frame1.height
        )
    )
    settingsPanelView.pop_addAnimation(frameAnim1, forKey: "CenterAnimation")
    
    let frame2 = soundsPanelView.frame
    let frameAnim2 = POPSpringAnimation(propertyNamed: kPOPViewFrame)
    frameAnim2.toValue =
      NSValue(CGRect:
        CGRect(
          x: show ? 0 : frame2.width,
          y: frame2.origin.y,
          width: frame2.width,
          height: frame2.height
        )
    )
    frameAnim2.animationDidReachToValueBlock = {[weak self] _ in
      guard let _self = self else {return}
      _self.layoutConstraintSettingsLeading.constant = show ? -_self.settingsPanelView.frame.width : 0
    }
    
    soundsPanelView.pop_addAnimation(frameAnim2, forKey: "CenterAnimation")
  }
  
  @IBAction func changeSound(sender: AnyObject) {
    actionButton?.type = .Back
    
    configActionButton()
    
    showSoundsList()

  }
  
  //MARK: UITableView Datasource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfSoundsInSection(section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SoundNameCell", forIndexPath: indexPath) as! STSoundNameTableViewCell
    cell.soundNameLabel.attributedText = viewModel.soundNameAtIndexPath(indexPath)
    return cell
  }
  
  
  //MARK: UITableView Delegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    viewModel.selectSoundAtIndexPath(indexPath)
    tableView.reloadData()
  }
  
}
