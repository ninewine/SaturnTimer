//
//  RCAlertView.swift
//  RocketAlarmClock
//
//  Created by Tidy Nine on 5/7/15.
//  Copyright (c) 2015 timeline. All rights reserved.
//



////////////////////////////////////////////////////
//
//  Rewrite SIAlertView With Swift, and some additional function.
//
//  SIAlertView
//  https://github.com/Sumi-Interactive/SIAlertView
//
////////////////////////////////////////////////////


import UIKit
import pop

let RCAlertViewWillShowNotification = "RCAlertViewWillShowNotification"
let RCAlertViewDidShowNotification = "RCAlertViewDidShowNotification"
let RCAlertViewWillDismissNotification = "RCAlertViewWillDismissNotification"
let RCAlertViewDidDismissNotification = "RCAlertViewDidDismissNotification"

let RCThemeColorHex: Int = 0x2BB4CB
let RCThemeFontName: String = "HelveticaNeue-Light"

enum RCAlertViewButtonType: Int {
  case Stroke = 0, Fill, Cancel
}

enum RCAlertViewBackgroundStyle: Int {
  case Gradient = 0, Solid
}

enum RCAlertViewButtonsListStyle: Int {
  case Normal = 0, Rows
}

enum RCAlertViewTransitionStyle: Int {
  case DropDown = 0, ActionSheet
}

typealias RCAlertViewHandler = (RCAlertView)->Void

let UIWindowLevelRCAlert: UIWindowLevel = 1999.0
let UIWindowLevelRCAlertBackground: UIWindowLevel = 1998.0

var __rc_alert_queue: NSMutableArray = NSMutableArray()
var __rc_alert_animating: Bool = false
var __rc_alert_current_view: RCAlertView?
var __rc_alert_background_window: RCAlertBackgroundWindow?

class RCAlertBackgroundWindow: UIWindow {
  var style: RCAlertViewBackgroundStyle?
  
  convenience init(frame: CGRect, style: RCAlertViewBackgroundStyle) {
    self.init(frame: frame)
    self.style = style
    self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    self.opaque = false
    self.windowLevel = UIWindowLevelRCAlertBackground
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    switch self.style! {
    case .Gradient:
      let locationsCount = 2
      let locations: [CGFloat] = [0.0, 1.0]
      let colors: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75]
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount)
      let center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)
      let radius = CGFloat(min(self.bounds.size.width, self.bounds.size.height))
      CGContextDrawRadialGradient(context, gradient, center, CGFloat(0.0), center, radius, CGGradientDrawingOptions.DrawsAfterEndLocation)
      
      break
    case .Solid:
      UIColor(white: 0.0, alpha: 0.5).set()
      CGContextFillRect(context, self.bounds)
      break
    }
  }
}

class RCAlertItem: NSObject {
  var title: String?
  var type: RCAlertViewButtonType?
  var action: RCAlertViewHandler?
}

class RCAlertButton : UIButton {
  var type: RCAlertViewButtonType?
  
  func setup () {
    self.addTarget(self, action: Selector("buttonTouchDown:"), forControlEvents: UIControlEvents.TouchDown)
    self.addTarget(self, action: Selector("buttonTouchUp:"), forControlEvents: UIControlEvents.TouchUpInside)
    self.addTarget(self, action: Selector("buttonTouchUp:"), forControlEvents: UIControlEvents.TouchUpOutside)
    self.addTarget(self, action: Selector("buttonTouchUp:"), forControlEvents: UIControlEvents.TouchCancel)
    
    switch self.type! {
    case .Stroke, .Cancel:
      self.layer.cornerRadius = self.bounds.size.height * 0.5
      self.layer.borderWidth = 1.0
      self.layer.borderColor = UIColor(hex:RCThemeColorHex).CGColor
      self.clipsToBounds = true
      self.setTitleColor(UIColor(hex:RCThemeColorHex), forState: UIControlState.Normal)
      break
    case .Fill:
      self.layer.cornerRadius = self.bounds.size.height * 0.5
      self.backgroundColor = UIColor(hex:RCThemeColorHex)
      self.clipsToBounds = true
      self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      break
    }
  }
  
  func buttonTouchDown (event: UIControlEvents) {
    UIView.animateWithDuration(0.1, animations: { () -> Void in
      if self.type == RCAlertViewButtonType.Fill {
        self.backgroundColor = UIColor(hex:RCThemeColorHex, alpha: 0.7)
      }
      else {
        self.layer.borderColor = UIColor(hex:RCThemeColorHex, alpha: 0.7).CGColor
      }
    })
  }
  
  func buttonTouchUp (event: UIControlEvents) {
    UIView.animateWithDuration(0.1, animations: { () -> Void in
      if self.type == RCAlertViewButtonType.Fill {
        self.backgroundColor = UIColor(hex:RCThemeColorHex)
      }
      else {
        self.layer.borderColor = UIColor(hex:RCThemeColorHex).CGColor
      }
    })
  }
}

class RCAlertCrossView: UIView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
    self.frame = CGRectMake(0, 0, 14, 14)
    let imageViewCross = UIImageView(image: UIImage(named: "pic-cross"))
    imageViewCross.frame = self.bounds
    self.addSubview(imageViewCross)
  }
}

class RCAlertViewController: UIViewController {
  var alertView: RCAlertView?
  
  override func loadView() {
    self.view = self.alertView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.alertView?.setup()
  }
  
  override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    self.alertView?.resetTransition()
    self.alertView?.invalidateLayout()
  }
  
  override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if let viewController = self.alertView?.oldKeyWindow?.currentViewController() {
      return viewController.supportedInterfaceOrientations()
    }
    return UIInterfaceOrientationMask.All
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    var window = self.alertView?.oldKeyWindow
    if window == nil {
      window = UIApplication.sharedApplication().windows[0]
    }
    return window!.viewControllerForStatusBarStyle()!.preferredStatusBarStyle()
  }

  override func prefersStatusBarHidden() -> Bool {
    var window = self.alertView?.oldKeyWindow
    if window == nil {
      window = UIApplication.sharedApplication().windows[0]
    }
    return window!.viewControllerForStatusBarStyle()!.prefersStatusBarHidden()
  }
}

class Block <T> {
  let f: T
  init (_ f:T) {
    self.f = f
  }
}

class RCAlertView: UIView, POPAnimationDelegate {
  
  let message_min_line_count = 3
  let message_max_line_count = 5
  let gap: CGFloat = 10.0
  let cancel_button_padding_top: CGFloat = 5.0
  var content_padding_left: CGFloat = 35.0
  let content_padding_right: CGFloat = 35.0
  let content_padding_top: CGFloat = 45.0
  let content_padding_bottom: CGFloat = 20.0
  let button_padding_top: CGFloat = 45.0
  let button_padding_left: CGFloat = 27.0
  let button_height: CGFloat = 44.0
  let cross_padding_left: CGFloat = 10.0
  let cross_padding_top: CGFloat = 10.0
  let cross_padding_bottom: CGFloat = 30.0
  let image_padding_left: CGFloat = 35.0
  
  var image_width: CGFloat = 76.0
  let container_width: CGFloat = 300.0

  var title: String? {
    didSet {
      self.invalidateLayout()
    }
  }
  var message: String? {
    didSet {
      self.invalidateLayout()
    }
  }
  var image: UIImage!{
    didSet {
      self.invalidateLayout()
    }
  }
  
  var singleImage: Bool? {
    didSet {
      self.invalidateLayout()
    }
  }
  var backgroundStyle = RCAlertViewBackgroundStyle.Gradient
  var buttonsListStyle = RCAlertViewButtonsListStyle.Normal
  var transitionStyleObj: Int = 0{
    didSet {
      if let style = RCAlertViewTransitionStyle(rawValue: self.transitionStyleObj) {
        self.transitionStyle = style
      }
    }
  }
  var transitionStyle = RCAlertViewTransitionStyle.DropDown {
    willSet {
      if newValue == .ActionSheet {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissWithActionSheetStyle")))
        self.backgroundStyle = .Solid
      }
    }
  }
  var willShowHandler: RCAlertViewHandler?
  var didShowHandler: RCAlertViewHandler?
  var willDismissHandler: RCAlertViewHandler?
  var didDidsmissHandler: RCAlertViewHandler?
  
  private(set) var visible: Bool = false
  
  var viewBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.6)
  var titleColor: UIColor = UIColor(hex: RCThemeColorHex)
  var messageColor: UIColor = UIColor.whiteColor()
  var titleFont: UIFont = UIFont(name: RCThemeFontName, size: 18.0)!
  var messageFont: UIFont = UIFont(name: RCThemeFontName, size: 15.0)!
  var buttonFont: UIFont = UIFont(name: RCThemeFontName, size: 15.0)!
  var buttonColor: UIColor = UIColor(hex: RCThemeColorHex)
  var cancelButtonColor: UIColor = UIColor(hex: RCThemeColorHex)
  var destructiveButtonColor: UIColor = UIColor(hex: RCThemeColorHex)
  var cornerRadius: CGFloat = 12.0
  
  var items: NSMutableArray?
  var oldKeyWindow: UIWindow?
  var alertWindow: UIWindow?
  var oldTintAdjustmentMode: UIViewTintAdjustmentMode?
  
  var titleLabel: UILabel?
  var messageLabel: UILabel?
  var imageView: UIImageView?
  var containerView: UIVisualEffectView?
  var buttons: NSMutableArray?
  var crosses: NSMutableArray?
  
  private(set) var layoutDirty: Bool = false
  
  convenience init (image: UIImage?) {
    self.init()
    self.title = nil
    self.message = nil
    if image != nil {
      self.singleImage = true
      image_width = container_width - (image_padding_left * 2.0)
      self.image = image!
    }
    self.items = NSMutableArray()
  }

  convenience init (title: String?, message: String?, image: UIImage?) {
    self.init()
    self.title = title
    self.message = message
    if image != nil {
      self.image = image!
      self.content_padding_left += (image_width + 12.0)
    }
    self.items = NSMutableArray()
  }
  
  //MARK: - Class Method
  
  class func shareQueue () -> NSMutableArray {
    return __rc_alert_queue
  }
  
  class func currentAlertView () -> RCAlertView? {
    return __rc_alert_current_view
  }
  
  class func setCurrentAlertView (alertView: RCAlertView?) {
    __rc_alert_current_view = alertView
  }
  
  class func isAnimating () -> Bool {
    return __rc_alert_animating
  }
  
  class func setAnimating (animating: Bool) {
    __rc_alert_animating = animating
  }
  
  class func showBackground () {
    if __rc_alert_background_window == nil {
      if let currentAlertView = RCAlertView.currentAlertView() {
        __rc_alert_background_window = RCAlertBackgroundWindow(frame: UIScreen.mainScreen().bounds, style: currentAlertView.backgroundStyle)
        __rc_alert_background_window?.makeKeyAndVisible()
        __rc_alert_background_window?.alpha = 0.0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
          __rc_alert_background_window?.alpha = 1.0
        })
      }
    }
  }
  
  class func hideBackground (animated: Bool) {
    if !animated {
      __rc_alert_background_window?.removeFromSuperview()
      __rc_alert_background_window = nil
      return
    }
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      __rc_alert_background_window?.alpha = 0.0
    }) { (flag) -> Void in
      __rc_alert_background_window?.removeFromSuperview()
      __rc_alert_background_window = nil
    }
  }

  //MARK: - Public
  func addButtonWithTitleObj(title: String, type: Int, handler:RCAlertViewHandler?) {
    if let type = RCAlertViewButtonType(rawValue: type) {
      self.addButtonWithTitle(title, type: type, handler: handler)
    }
  }
  
  func addButtonWithTitle(title: String, type: RCAlertViewButtonType, handler:RCAlertViewHandler?) {
    let item = RCAlertItem()
    item.title = title
    item.type = type
    item.action = handler
    self.items?.addObject(item)
  }
  
  func show () {
    if self.visible {
      return
    }
    
    self.oldKeyWindow = UIApplication.sharedApplication().keyWindow
    self.oldTintAdjustmentMode = self.oldKeyWindow?.tintAdjustmentMode
    self.oldKeyWindow?.tintAdjustmentMode = UIViewTintAdjustmentMode.Dimmed
    
    if !RCAlertView.shareQueue().containsObject(self) {
      RCAlertView.shareQueue().addObject(self)
    }
    
    if RCAlertView.isAnimating() {
      return
    }
    
    if let alert = RCAlertView.currentAlertView() {
      if alert.visible {
        alert.dismiss(true, cleanUp: false)
        return
      }
    }
    
    if self.willShowHandler != nil {
      self.willShowHandler!(self)
    }
    
    NSNotificationCenter.defaultCenter().postNotificationName(RCAlertViewWillShowNotification, object: self)
    
    self.visible = true
    
    RCAlertView.setAnimating(true)
    RCAlertView.setCurrentAlertView(self)

    RCAlertView.showBackground()

    let viewController = RCAlertViewController()
    viewController.alertView = self
    
    if self.alertWindow == nil {
      let window = UIWindow(frame: UIScreen.mainScreen().bounds)
      window.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
      window.opaque = false
      window.windowLevel = UIWindowLevelRCAlert
      window.rootViewController = viewController
      self.alertWindow = window
    }
    self.alertWindow?.makeKeyAndVisible()
    
    self.validateLayout()
    
    let inCompletion = Block<()->()> {
      if self.didShowHandler != nil{
        self.didShowHandler!(self)
      }
      
      NSNotificationCenter.defaultCenter().postNotificationName(RCAlertViewDidShowNotification, object: self)
      
      RCAlertView.setAnimating(false)
      
      let index = RCAlertView.shareQueue().indexOfObject(self)
      if index < RCAlertView.shareQueue().count - 1 {
        self.dismiss(true, cleanUp: false)
      }
    }
    
    self.transitionInCompletion(inCompletion)
  }
  
  func hide(animated: Bool, afterDelay: Double) {
    let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(afterDelay) * Double(NSEC_PER_SEC)))
    dispatch_after(dispatchTime, dispatch_get_main_queue(), {[unowned self] () -> Void in
      self.dismiss(animated)
      })
  }
  
  func dismissWithActionSheetStyle () {
    RCAlertView.setAnimating(true)
    self.dismiss(true, cleanUp: true)
  }
  
  func dismiss(animated: Bool) {
    self.dismiss(animated, cleanUp: true)
  }
  
  func dismiss(animated: Bool, cleanUp: Bool) {
    let isVisible = self.visible
    
    if isVisible {
      if self.willDismissHandler != nil {
        self.willDismissHandler!(self)
      }
      NSNotificationCenter.defaultCenter().postNotificationName(RCAlertViewWillDismissNotification, object: self)
    }
    
    let completion = Block<()->()> {
      self.visible = false
      self.teardown()
      
      RCAlertView.setCurrentAlertView(nil)
      
      var nextAlertView: RCAlertView?
      let index = RCAlertView.shareQueue().indexOfObject(self)
      if index != NSNotFound && index < RCAlertView.shareQueue().count - 1 {
        nextAlertView = RCAlertView.shareQueue().objectAtIndex(index + 1) as? RCAlertView
      }
      
      if cleanUp {
        RCAlertView.shareQueue().removeObject(self)
      }
      
      RCAlertView.setAnimating(false)
      
      if isVisible {
        if self.didDidsmissHandler != nil {
          self.didDidsmissHandler!(self)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(RCAlertViewDidDismissNotification, object: self)
      }
      
      if !isVisible {
        return
      }
      
      if nextAlertView != nil {
        nextAlertView!.show()
      }
      else {
        if RCAlertView.shareQueue().count > 0 {
          if let alert = RCAlertView.shareQueue().lastObject as? RCAlertView{
            alert.show()
          }
        }
      }
    }
    
    if animated && isVisible {
      RCAlertView.setAnimating(true)
      self.transitionOutCompletion(completion)
      
      if RCAlertView.shareQueue().count == 1 {
        RCAlertView.hideBackground(true)
      }
    }
    else {
      completion.f()
      if RCAlertView.shareQueue().count == 0 {
        RCAlertView.hideBackground(true)
      }
    }
    
    var window = self.oldKeyWindow
    if window == nil {
      window = UIApplication.sharedApplication().windows[0]
    }
    if window != nil{
      if let mode = self.oldTintAdjustmentMode {
        window!.tintAdjustmentMode = mode
      }
      window!.makeKeyAndVisible()
      window!.hidden = false
    }
  }
  
  //MARK: - transition
  
  func transitionInCompletion(completion: Block<()->()>) {
    if let containerView = self.containerView {
      switch self.transitionStyle {
      case .DropDown:
        var rect = containerView.frame
        let originalRect = rect
        rect.origin.y = -rect.size.height
        containerView.frame = rect
        
        let dropAnim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        dropAnim.springBounciness = 4
        dropAnim.springSpeed = 9
        dropAnim.delegate = self
        dropAnim.toValue = originalRect.origin.y + originalRect.size.height * 0.5
        dropAnim.setValue(completion, forKey: "handler")
        containerView.layer.pop_addAnimation(dropAnim, forKey: "drop")
        
        let rotateAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        rotateAnim.springBounciness = 4
        rotateAnim.springSpeed = 9
        rotateAnim.fromValue = -M_PI_4 * 0.1
        rotateAnim.toValue = 0.0
        containerView.layer.pop_addAnimation(rotateAnim, forKey: "drop_rotate")
        break
      case .ActionSheet:
        let toRect = containerView.frame
        containerView.frame.origin.y = self.bounds.height
        let popAnim = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        popAnim.springBounciness = 4
        popAnim.springSpeed = 12
        popAnim.delegate = self
        popAnim.toValue = NSValue(CGRect:toRect)
        popAnim.setValue(completion, forKey: "handler")
        containerView.pop_addAnimation(popAnim, forKey: "pop")
        break
      }
    }
  }
  
  func transitionOutCompletion(completion: Block<()->()>) {
    if let containerView = self.containerView {
      switch self.transitionStyle {
      case .DropDown:
        let dropAnim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        dropAnim.springBounciness = 4
        dropAnim.springSpeed = 5
        dropAnim.delegate = self
        dropAnim.toValue = self.bounds.size.height + containerView.frame.size.height
        dropAnim.setValue(completion, forKey: "handler")
        containerView.layer.pop_addAnimation(dropAnim, forKey: "drop")
        
        let rotateAnim = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        rotateAnim.springBounciness = 4
        rotateAnim.springSpeed = 5
        rotateAnim.fromValue = 0.0
        rotateAnim.toValue = -M_PI_4 * 0.1
        containerView.layer.pop_addAnimation(rotateAnim, forKey: "drop_rotate")
        break
      case .ActionSheet:
        var toRect = containerView.frame
        toRect.origin.y = self.bounds.height
        let popAnim = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        popAnim.springBounciness = 4
        popAnim.springSpeed = 12
        popAnim.delegate = self
        popAnim.toValue = NSValue(CGRect:toRect)
        popAnim.setValue(completion, forKey: "handler")
        containerView.pop_addAnimation(popAnim, forKey: "pop")
        break
      }
    }
    
  }
  
  func resetTransition () {
    self.containerView?.layer.pop_removeAllAnimations()
  }
  
  //MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.validateLayout()
  }
  
  func invalidateLayout () {
    self.layoutDirty = true
    self.setNeedsLayout()
  }
  
  func validateLayout () {
    if !self.layoutDirty {
      return
    }
    self.layoutDirty = false
    
    if let containerView = self.containerView {
      let height = self.preferredHeight()
      var left: CGFloat = 0
      var top: CGFloat = 0
      var width: CGFloat = 0
      switch self.transitionStyle {
      case .DropDown:
        left = (self.bounds.size.width - container_width) * 0.5
        top = (self.bounds.size.height - height) * 0.5
        width = container_width
        break
      case .ActionSheet:
        left = 0.0
        top = self.bounds.size.height - height
        width = self.bounds.size.width
      }

      containerView.transform = CGAffineTransformIdentity
      containerView.frame = CGRectMake(left, top, width, height)
      
      var y = content_padding_top
      
      if self.titleLabel != nil && self.title != nil{
        self.titleLabel?.text = self.title!
        let height = self.heightForTitleLabel()
        self.titleLabel?.frame = CGRectMake(content_padding_left, y, containerView.bounds.size.width - content_padding_left - content_padding_right, height)
        y += height
      }
      
      if self.messageLabel != nil && self.messageLabel != nil{
        if y > content_padding_top {
          y += gap
        }
        
        self.messageLabel?.text = self.message!
        let height = self.heightForMessageLabel()
        self.messageLabel?.frame = CGRectMake(content_padding_left, y, containerView.bounds.size.width - content_padding_left - content_padding_right, height)
        y += height
      }
      
      if self.imageView != nil && self.image != nil {
        if let _ = self.singleImage {
          self.imageView?.frame = CGRectMake(image_padding_left, content_padding_top, image_width, image_width)
          y += image_width
        }
        else {
          self.imageView?.frame = CGRectMake(image_padding_left, content_padding_top, image_width, y - content_padding_top)
        }
      }
      
      if self.transitionStyle != .ActionSheet {
        if self.crosses?.count > 0 {
          for i in 0..<self.crosses!.count {
            if let crossView = self.crosses?.objectAtIndex(i) as? RCAlertCrossView {
              let crossWidth = crossView.bounds.size.width, crossHeight = crossView.bounds.size.height
              var point = CGPointZero
              switch i {
              case 0:
                point = CGPointMake(cross_padding_left, cross_padding_top)
                break
              case 1:
                point = CGPointMake((container_width - crossWidth) * 0.5, cross_padding_top)
                break
              case 2:
                point = CGPointMake(container_width - crossWidth - cross_padding_left, cross_padding_top)
                break
              case 3:
                point = CGPointMake(cross_padding_left, (y + button_padding_top - crossHeight) * 0.5)
                break
              case 4:
                point = CGPointMake(container_width - crossWidth - cross_padding_left, (y + button_padding_top - crossHeight) * 0.5)
                break
              case 5:
                point = CGPointMake(cross_padding_left, y + button_padding_top - crossHeight * 1.5)
                break
              case 6:
                point = CGPointMake((container_width - crossWidth) * 0.5, y + button_padding_top - crossHeight * 1.5)
                break
              case 7:
                point = CGPointMake(container_width - crossWidth - cross_padding_left,  y + button_padding_top - crossHeight * 1.5)
                break
              default:
                break
              }
              var rect = crossView.frame
              rect.origin = point
              crossView.frame = rect
            }
          }
        }
      }
      
      
      
      if self.items?.count > 0 {
        if y > content_padding_top {
          y += (gap + button_padding_top)
        }
        
        if self.items?.count == 2 && self.transitionStyle != .ActionSheet {
          let width = (containerView.bounds.size.width - button_padding_left * 2 - gap) * 0.5
          if let button = self.buttons?.objectAtIndex(0) as? RCAlertButton {
            button.frame = CGRectMake(button_padding_left, y, width, button_height)
            button.setup()
          }
          if let button = self.buttons?.objectAtIndex(1) as? RCAlertButton {
            button.frame = CGRectMake(button_padding_left + width + gap, y, width, button_height)
            button.setup()
          }
        }
        else {
          for i in 0..<self.buttons!.count {
            if let button = self.buttons?.objectAtIndex(i) as? RCAlertButton {
              button.frame = CGRectMake(button_padding_left, y, containerView.bounds.size.width - button_padding_left * 2, button_height)
              button.setup()
              if self.buttons!.count > 1 {
                if i == self.buttons!.count - 1 && (self.items?.objectAtIndex(i) as? RCAlertItem)?.type == RCAlertViewButtonType.Cancel {
                  var rect = button.frame
                  rect.origin.y += cancel_button_padding_top
                  button.frame = rect
                }
                y += button_height + gap
              }
            }
          }
        }
      }
    }

  }
  
  func preferredHeight () -> CGFloat {
    var height = content_padding_top
    if self.title != nil {
      height += self.heightForTitleLabel()
    }
    
    if self.message != nil {
      if height > content_padding_top {
        height += gap
      }
      height += self.heightForMessageLabel()
    }
    
    if let _ = self.singleImage{
      height += self.image_width
    }
    
    if self.items?.count > 0 {
      if height > content_padding_top {
        height += (gap + button_padding_top)
      }
      if self.items!.count <= 2 && self.transitionStyle != .ActionSheet {
        height += button_height
      }
      else {
        height += (button_height + gap) * CGFloat(self.items!.count) - gap
        if self.buttons!.count > 2 && (self.items?.lastObject as? RCAlertItem)?.type == RCAlertViewButtonType.Cancel {
          height += cancel_button_padding_top
        }
      }
    }
    else {
      if height > content_padding_top {
        height += cross_padding_bottom
      }
    }
    height += content_padding_bottom
    return height
    
  }
  
  func heightForTitleLabel () -> CGFloat {
    if self.titleLabel != nil && self.title != nil {
      let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
      paragraphStyle.lineBreakMode = self.titleLabel!.lineBreakMode
      let attrs = [
        NSFontAttributeName: self.titleLabel!.font,
        NSParagraphStyleAttributeName: paragraphStyle
      ]
      let title: NSString = self.title!
      let maxHeight = self.titleLabel!.font.lineHeight
      let rect = title.boundingRectWithSize(CGSizeMake(container_width - content_padding_left - content_padding_right, maxHeight), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil)
      return rect.size.height
    }
    return 0.0
  }
  
  func heightForMessageLabel () -> CGFloat {
    if self.messageLabel != nil && self.message != nil {
      let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
      paragraphStyle.lineBreakMode = self.messageLabel!.lineBreakMode
      let attrs = [
        NSFontAttributeName: self.messageLabel!.font,
        NSParagraphStyleAttributeName: paragraphStyle
      ]
      let title: NSString = self.message!
      let maxHeight = CGFloat(message_max_line_count) * self.messageLabel!.font.lineHeight
      let rect = title.boundingRectWithSize(CGSizeMake(container_width - content_padding_left - content_padding_right, maxHeight), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil)
      return rect.size.height
    }
    return 0.0
  }
  
  //MARK: - setup
  
  func setup () {
    self.setupContainerView()
    self.updateTitleLabel()
    self.updateMessageLabel()
    self.setupButtons()
    self.setupCrosses()
    self.updateImageView()
    self.invalidateLayout()
  }
  
  func teardown () {
    self.containerView?.removeFromSuperview()
    self.containerView = nil
    self.titleLabel = nil
    self.messageLabel = nil
    self.buttons?.removeAllObjects()
    self.crosses?.removeAllObjects()
    self.alertWindow?.hidden = true
    self.alertWindow?.removeFromSuperview()
    self.alertWindow?.alpha = 0.0
    self.alertWindow = nil
    self.layoutDirty = false
  }
  
  func setupContainerView () {
    self.containerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    self.containerView?.frame = self.bounds
    self.containerView?.layer.cornerRadius = self.cornerRadius
    self.containerView?.clipsToBounds = true
    self.addSubview(self.containerView!)
  }
  
  func updateTitleLabel () {
    if let title = self.title {
      if self.titleLabel == nil {
        self.titleLabel = UILabel()
        self.titleLabel?.textAlignment = NSTextAlignment.Center
        self.titleLabel?.backgroundColor = UIColor.clearColor()
        self.titleLabel?.font = self.titleFont
        self.titleLabel?.textColor = self.titleColor
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
        if self.image != nil {
          self.titleLabel?.textAlignment = NSTextAlignment.Left
        }
        self.containerView?.contentView.addSubview(self.titleLabel!)
      }
      self.titleLabel?.text = title
    }
    else {
      self.titleLabel?.removeFromSuperview()
      self.titleLabel = nil
    }
    self.invalidateLayout()
  }
  
  func updateMessageLabel () {
    if let message = self.message {
      if self.messageLabel == nil {
        self.messageLabel = UILabel()
        self.messageLabel?.textAlignment = NSTextAlignment.Center
        self.messageLabel?.backgroundColor = UIColor.clearColor()
        self.messageLabel?.font = self.messageFont
        self.messageLabel?.textColor = self.messageColor
        self.messageLabel?.adjustsFontSizeToFitWidth = true
        self.messageLabel?.numberOfLines = message_max_line_count
        self.messageLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        if self.image != nil {
          self.messageLabel?.textAlignment = NSTextAlignment.Left
        }
        self.containerView?.contentView.addSubview(self.messageLabel!)
      }
      self.messageLabel?.text = message
    }
    else {
      self.messageLabel?.removeFromSuperview()
      self.messageLabel = nil
    }
    self.invalidateLayout()
  }
  
  func setupButtons () {
    if let items = self.items {
      self.buttons = NSMutableArray(capacity: items.count)
      for i in 0..<items.count {
        if let button = self.buttonForItemIndex(i) {
          self.buttons?.addObject(button)
          self.containerView?.contentView.addSubview(button)
        }
      }
    }
  }
  
  func buttonForItemIndex(index: Int) -> UIButton? {
    if let item = self.items?.objectAtIndex(index) as? RCAlertItem {
      let button = RCAlertButton()
      button.type = item.type
      button.tag = index
      button.autoresizingMask = UIViewAutoresizing.FlexibleWidth
      button.titleLabel?.font = self.buttonFont
      button.setTitle(item.title, forState: UIControlState.Normal)
      button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
      return button
    }
    return nil
  }
  
  func buttonAction(button: UIButton) {
    RCAlertView.setAnimating(true)
    if let item = self.items?.objectAtIndex(button.tag) as? RCAlertItem {
      if let action = item.action {
        action(self)
      }
    }
    self.dismiss(true)
  }
  
  func setupCrosses () {
    if self.transitionStyle == .ActionSheet {
      return
    }
    let crossCount = 8
    self.crosses = NSMutableArray(capacity: crossCount)
    for _ in 0..<crossCount {
      let crossView = RCAlertCrossView(frame: CGRectZero)
      self.crosses?.addObject(crossView)
      self.containerView?.addSubview(crossView)
    }
  }
  
  func updateImageView () {
    if let image = self.image {
      if self.imageView == nil {
        self.imageView = UIImageView(image: image)
        self.imageView?.frame = CGRectZero
        self.imageView?.contentMode = UIViewContentMode.Center
        self.containerView?.addSubview(self.imageView!)
      }
    }
  }
  
  //MARK: - Pop Animation Delegate
  
  func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
    if let completion = anim.valueForKey("handler") as? Block<()->()> {
      completion.f()
    }
  }
}
