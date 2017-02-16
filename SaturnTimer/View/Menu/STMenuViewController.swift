//
//  STMenuViewController.swift
//  SaturnTimer
//
//  Created by Tidy Nine on 2/27/16.
//  Copyright © 2016 Tidy Nine. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import pop

class STMenuViewController: STViewController, UITableViewDataSource, UITableViewDelegate {
  fileprivate var viewModel: STMenuViewModel = STMenuViewModel()

  weak var actionButton: STActionButton?
  
  @IBOutlet weak var saturn: Saturn!
  @IBOutlet weak var sandglass: Sandglass!
  @IBOutlet weak var television: Television!
  @IBOutlet weak var plate: Plate!
  
  @IBOutlet weak var constraintLeadingSettings: NSLayoutConstraint!
  @IBOutlet weak var constraintTopSettingsLabel: NSLayoutConstraint!
  @IBOutlet weak var constraintTopTagsLabel: NSLayoutConstraint!
  @IBOutlet weak var constraintTopSoundsLabel: NSLayoutConstraint!
  @IBOutlet weak var constraintTopSandglass: NSLayoutConstraint!
  
  @IBOutlet weak var soundNameLabel: UILabel!
  
  @IBOutlet weak var soundListTableView: UITableView!
  
  @IBOutlet weak var settingsPanelView: UIView!
  @IBOutlet weak var soundsPanelView: UIView!
  
  fileprivate var activeTagView: AnimatableTag?
  
  fileprivate var actionButtonDisposable: Disposable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    // Do any additional setup after loading the view.
  }
  
  func bindViewModelToHomeViewModel(_ viewModel: STHomeViewModel) {
    self.viewModel.tagType.value = viewModel.tagType.value
    self.viewModel.soundFileName.value = viewModel.soundFileName.value
    
    viewModel.tagType <~ self.viewModel.tagType
    viewModel.soundFileName <~ self.viewModel.soundFileName
    
    self.viewModel.soundFileName
      .producer
      .observe(on: QueueScheduler.main)
      .map {$0.replacingOccurrences(of: ".mp3", with: "")}
      .startWithValues {[weak self] (soundName) -> () in
        self?.soundNameLabel?.text = soundName
    }
    
  }
  
  func configView() {
    configTagView()
    
    switch HelperCommon.currentDeviceType {
    case .iPhone4:
      constraintTopSettingsLabel.constant = 20
      constraintTopSoundsLabel.constant = 20
      constraintTopSandglass.constant = 10
      break
    case .iPhone6, .iPhone6Plus:
      constraintTopTagsLabel.constant = 70
      break
    case .iPad:
      constraintTopSettingsLabel.constant = 150
      constraintTopSoundsLabel.constant = 150
      constraintTopTagsLabel.constant = 80
      break
    default:
      break
    }
    
    if HelperCommon.currentDeviceType == .iPhone4 {
      constraintTopSettingsLabel.constant = 20
      constraintTopSoundsLabel.constant = 20
      constraintTopSandglass.constant = 10
    }
    else if HelperCommon.currentDeviceType == .iPad {
      constraintTopSettingsLabel.constant = 150
      constraintTopSoundsLabel.constant = 150
    }
  }
  
  func configTagView() {
    if let tagTypeName = UserDefaults.standard.string(forKey: HelperConstant.UserDefaultKey.CurrentTagTypeName) {
      if let type = STTagType(rawValue: tagTypeName) {
        activateTag(type)
      }
    }
    
    saturn.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      self?.activateTag(.SaturnType)
    }

    sandglass.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      self?.activateTag(.SandglassType)
    }
    
    television.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      self?.activateTag(.TelevisionType)
    }
    
    plate.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      self?.activateTag(.PlateType)
    }
    
  }
  
  func configActionButton () {
    //subscribe for one open-close operation
    actionButtonDisposable = actionButton?.reactive.controlEvents(.touchUpInside).observeValues {[weak self] (button) in
      button.type = .close
      self?.actionButtonDisposable?.dispose()
      self?.actionButtonDisposable = nil
      self?.hideSoundsList()
    }
  }
  
  func activateTag(_ type: STTagType) {
    
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
    
    CocoaAction<Any>(viewModel.changeTagAction, { _ in return type }).execute(())
  }
  
  func showSoundsList () {
    moveSoundsList(true)
  }
  
  func hideSoundsList () {
    viewModel.audioPlayer?.stop()
    moveSoundsList(false)
  }
  
  func moveSoundsList (_ show: Bool) {
    constraintLeadingSettings.constant = show ? -settingsPanelView.frame.width : 0

    let frame1 = settingsPanelView.frame
    let frameAnim1 = POPSpringAnimation(propertyNamed: kPOPViewFrame)

    frameAnim1?.toValue =
      NSValue(cgRect:
        CGRect(
          x: show ? -frame1.width : 0,
          y: frame1.origin.y,
          width: frame1.width,
          height: frame1.height
        )
    )
    settingsPanelView.pop_add(frameAnim1, forKey: "CenterAnimation")
    
    let frame2 = soundsPanelView.frame
    let frameAnim2 = POPSpringAnimation(propertyNamed: kPOPViewFrame)
    frameAnim2?.toValue =
      NSValue(cgRect:
        CGRect(
          x: show ? 0 : frame2.width,
          y: frame2.origin.y,
          width: frame2.width,
          height: frame2.height
        )
    )
//    frameAnim2.animationDidReachToValueBlock = {[weak self] _ in
//      guard let _self = self else {return}
//      _self.layoutConstraintSettingsLeading.constant = show ? -_self.settingsPanelView.frame.width : 0
//    }
    
    soundsPanelView.pop_add(frameAnim2, forKey: "CenterAnimation")
  }
  
  @IBAction func changeSound(_ sender: AnyObject) {
    actionButton?.type = .back
    
    configActionButton()
    
    showSoundsList()

  }
  
  //MARK: UITableView Datasource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfSoundsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SoundNameCell", for: indexPath) as! STSoundNameTableViewCell
    cell.soundNameLabel.attributedText = viewModel.soundNameAtIndexPath(indexPath)
    return cell
  }
  
  
  //MARK: UITableView Delegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectSoundAtIndexPath(indexPath)
    tableView.reloadData()
  }
  
}
