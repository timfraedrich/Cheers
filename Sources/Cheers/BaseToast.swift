//
//  BaseToast.swift
//
//  Cheers
//  Copyright (C) 2021 Tim Fraedrich <tim@tadris.de>
//

import UIKit
import SnapKit

open class BaseToast: UIView {
    
    /// The closure being run on display or resume of the toast
    public var onDisplay: ((BaseToast) -> Void)?
    
    /// The closure being run on dismiss of the toast
    public var onDismiss: ((BaseToast) -> Void)?
    
    /// The corner radius used for rounding off the toast
    public var cornerRadius: CGFloat = Cheers.Preferences.cornerRadius
    
    /// The spacing around the toast; meaning the distance it will have to the edge of the screen
    public var spacing: CGFloat = Cheers.Preferences.spacing
    
    /// The height and width of the dismiss button
    public var dismissButtonSize: CGFloat = Cheers.Preferences.dismissButtonSize
    
    /// The effect view used to display a blur effect as the background of the toast
    private lazy var effectView: UIVisualEffectView = {
        
        let effectView = UIVisualEffectView()
        
        effectView.effect = UIBlurEffect(style: .regular)
        effectView.clipsToBounds = true
        effectView.layer.cornerRadius = self.cornerRadius
        
        return effectView
        
    }()
    
    /// The button used to manually dismiss the toast
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        
        let image = UIImage(
            named: "close",
            in: Bundle.package,
            compatibleWith: .none
        )?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
        
    }()
    
    /// The queue the toast will be placed on
    internal var queue: ToastQueue = .default
    
    /// The duration the toast will be displayed; set to `nil` if the toast should not dismiss after a certain time
    public var duration: TimeInterval? = Cheers.Preferences.duration
    
    /// If `true` the toast can be dismissed by the user, otherwise it can only be dismissed after the duration delay or manually
    public let isDismissable: Bool
    
    /// If `true` the toast is currently being displayed
    public private(set) var isBeingDisplayed: Bool = false
    
    /// If `true` the toast was suspended by the queue to immediately display another toast; the toast is invisible
    public private(set) var isSuspended: Bool = false
    
    /// The content view of the toast; to customise you should use the customise block when initialising
    public private(set) var contentView: UIView = UIView()
    
    /**
     Initialises the `BaseToast` with a modified content view
     - parameter customise: a block being called with reference to this `BaseToast` and the content view of it; this should be used to customise the content view
     - note: Views added to the content view inside the customise block should have propper constraints set up or the content view should be assigned a frame
     */
    public init(customise: ((BaseToast, UIView) -> Void)? = nil, isDismissable: Bool = Cheers.Preferences.isDismissable) {
        
        self.isDismissable = isDismissable
        
        super.init(frame: .zero)
        
        self.tintColor = Cheers.Preferences.tintColor
        
        self.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        
        self.layer.cornerRadius = self.cornerRadius
        self.backgroundColor = Cheers.Preferences.backgroundColor
        
        self.addSubview(effectView)
        self.addSubview(contentView)
        
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(spacing)
        }
        
        if self.isDismissable {
            
            self.addSubview(dismissButton)
            
            dismissButton.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-self.spacing)
                make.width.height.equalTo(self.dismissButtonSize)
                make.left.equalTo(contentView.snp.right).offset(self.spacing)
            }
            
            dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            
        } else {
            
            contentView.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-self.spacing)
            }
            
        }
        
        customise?(self, contentView)
        
        // somehow setting the size leads to the auto layout constraints not conflicting
        self.frame.size = self.calculatedSize
        
    }
    
    required public init?(coder: NSCoder) {
        self.isDismissable = true
        super.init(coder: coder)
    }
    
    /**
     Displays the toast 
     */
    internal func display() {
        
        guard !self.isBeingDisplayed else {
            return
        }
        
        if let window = UIApplication.shared.keyWindow {
            
            window.windowLevel = .statusBar + 1
            
            window.addSubview(self)
            
            self.isBeingDisplayed = true
            self.scheduleAutoDismiss()
            
            self.onDisplay?(self)
            
            self.frame = self.calculatedStartFrame
            
            self.animate(animations: {
                
                self.frame = self.calculatedEndFrame
                
            })
            
        }
        
    }
    
    /**
     Suspends the display and auto dismissal of the toast to make room for another on the condition that it is being displayed and it is not suspended already
     */
    internal func suspend() {
        
        guard self.isBeingDisplayed, !self.isSuspended else {
            return
        }
        
        self.isSuspended = true
        self.cancleAutoDismiss()
        
        self.animate(animations: {
            
            self.alpha = 0
            
        }, completion: { finished in
            
            self.isHidden = true
            
        })
        
    }
    
    /**
     Resumes the display and restarts the auto dismissal of the toast after the toast responsible for the suspension was dismissed on the condition that it is being displayed and currently suspended
     */
    internal func resume() {
        
        guard self.isBeingDisplayed, self.isSuspended else {
            return
        }
        
        self.isSuspended = false
        self.scheduleAutoDismiss()
        
        self.onDisplay?(self)
        
        self.isHidden = false
        
        self.animate(animations: {
            
            self.alpha = 1
            
        })
        
    }
    
    /**
     Dismisses the toast on the condition that it is being displayed
     */
    @objc public func dismiss() {
        
        guard self.isBeingDisplayed else {
            return
        }
        
        self.isBeingDisplayed = false
        self.isSuspended = false
        
        self.onDismiss?(self)
        
        self.animate(animations: {
            
            self.frame = self.calculatedStartFrame
            
        }, completion: { finished in
            
            self.removeFromSuperview()
            self.queue.displayNext()
            
        })
        
        
    }
    
    /// The calculated `CGSize` of the toast based on auto layout constraints
    private var calculatedSize: CGSize {
        let referenceSize = CGSize(
            width: UIScreen.main.bounds.width - ( 2 * self.spacing ),
            height: (UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height ?? UIScreen.main.bounds.height) - ( 2 * self.spacing )
        )
        let size = self.systemLayoutSizeFitting(
            referenceSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return size
    }
    
    /// The calculated `CGPoint` for the start frame of the toast for it to be out of screen
    private var calculatedStartOrigin: CGPoint {
        return CGPoint(x: self.spacing, y: -self.calculatedSize.height)
    }
    
    /// The calculated `CGPoint` for the end frame of the toast for it to be on the screen
    private var calculatedEndOrigin: CGPoint {
        return CGPoint(x: self.spacing, y: self.spacing + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0))
    }
    
    /// The start frame of the toast, being the first and last postion of the toast in the display process
    private var calculatedStartFrame: CGRect {
        return CGRect(origin: self.calculatedStartOrigin, size: self.calculatedSize)
    }
    
    /// The end frame of the toast, being the final position when displaying
    private var calculatedEndFrame: CGRect {
        return CGRect(origin: self.calculatedEndOrigin, size: self.calculatedSize)
    }
    
    /**
     Animates the animation block with `UIView.animate` and constant properties
     - parameter animations: the animations being performed
     - parameter completion: the completion block being handed to `UIView.animate`
     */
    private func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
        
    }
    
    /**
     Automatically dismisses the toast after the specified duration
     */
    private func scheduleAutoDismiss() {
        
        if let duration = self.duration {
            
            self.perform(#selector(dismiss), with: nil, afterDelay: duration)
            
        }
        
    }
    
    /**
     Cancles perviously scheduled auto dismisses
     */
    private func cancleAutoDismiss() {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        
    }
    
}
