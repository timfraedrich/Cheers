//
//  Cheers.swift
//
//  Cheers
//  Copyright (C) 2021 Tim Fraedrich <tim@tadris.de>
//

import Foundation
import UIKit

public final class Cheers {
    
    @available(*, unavailable)
    init() {}
    
    /**
     Shows the toast on a queue as specified
     - parameter queue: the queue the toast will be placed on
     - parameter queuePosition: the `QueuePosition` the toast will be placed at in the queue
     */
    public static func show(_ toast: BaseToast, on queue: ToastQueue = .default, at queuePosition: QueuePosition = .back) {
        
        if !toast.isBeingDisplayed {
            
            toast.queue = queue
            queue.add(toast, position: queuePosition)
        }
        
    }
    
    /**
     Dismisses the current toast and clears the queue
     - parameter queue: the queue managing the toasts that should be aborted
     */
    public static func abortAll(on queue: ToastQueue = .default) {
        
        queue.abort()
        
    }
    
    // MARK: - Preferences
    
    /**
     A class dedicated to make default preferences applying to all toasts being created.
     */
    public final class Preferences {
        
        @available(*, unavailable)
        init() {}
        
        /// The default duration a toast will be displayed; set to `nil` if the toast should not be dismissed.
        /// - Note: if set to `nil` you need to dismiss every toast individually.
        public static var duration: TimeInterval? = 10
        
        /// A boolean indicating whether toasts should be dismissable by the user through a button tap.
        public static var isDismissable: Bool = true
        
        /// The default color used for the background of a toast.
        public static var backgroundColor: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground.withAlphaComponent(0.5)
            } else {
                return UIColor.white.withAlphaComponent(0.5)
            }
        }()
        
        /// The default tint color used for all subviews of this view
        public static var tintColor: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.label.withAlphaComponent(0.5)
            } else {
                return UIColor.black.withAlphaComponent(0.5)
            }
        }()
        
        /// The default corner radius used for rounding off the toast.
        public static var cornerRadius: CGFloat = 16
        
        /// The default spacing around the toast and the contentView inside.
        public static var spacing: CGFloat = 16
        
        /// The default height and width of the dismiss button.
        public static var dismissButtonSize: CGFloat = 36
        
    }
    
}
