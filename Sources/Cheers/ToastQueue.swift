//
//  ToastQueue.swift
//
//  Cheers
//  Copyright (C) 2021 Tim Fraedrich <tim@tadris.de>
//

import Foundation

public class ToastQueue {
    
    /// The default instance of `ToastQueue`
    public static let `default` = ToastQueue()
    
    /// The `BaseToast` currently in the queue
    public private(set) var toasts: [BaseToast] = []
    
    /// The number of toasts in the queue
    public var count: Int {
        return self.toasts.count
    }
    
    /**
     Adds an `BaseToast` to the queue
     - parameter toast: The toast being added to the queue
     - parameter position: The `Position` where a toast will be added to the queue
     */
    internal func add(_ toast: BaseToast, position: QueuePosition = .back) {
        
        switch position {
            
        case .back:
            
            self.toasts.append(toast)
            
            if self.toasts.firstIndex(of: toast) == 0 {
                
                toast.display()
                
            }
            
        case .front:
            
            if let firstBanner = self.toasts.first {
                
                firstBanner.suspend()
                
            }
            
            self.toasts.insert(toast, at: 0)
            
            toast.display()
            
        }
        
    }
    
    /**
     Removes an `BaseToast` from the queu
     - parameter toast: The toast being removed from the queue
     */
    internal func remove(_ toast: BaseToast) {
        
        if let toastIndex = self.toasts.firstIndex(of: toast) {
            
            self.toasts.remove(at: toastIndex)
            
        }
        
    }
    
    /**
     Displayes (or resumes) the next toast after removing the current toast from the queue
     */
    internal func displayNext() {
        
        if !self.toasts.isEmpty {
            
            let toast = self.toasts.removeFirst()
            
            if toast.isBeingDisplayed {
                
                toast.dismiss()
                
            }
            
        }
        
        if let nextBanner = self.toasts.first {
            
            if nextBanner.isSuspended {
                
                nextBanner.resume()
                
            } else {
                
                nextBanner.display()
                
            }
            
        }
        
    }
    
    /**
     Clears the queue by removing all toasts
     */
    internal func clear() {
        
        self.toasts.removeAll()
        
    }
    
    /**
     Aborts the queue by dismissing the current toast and clearing itself
     */
    internal func abort() {
        
        for toast in toasts where toast.isBeingDisplayed {
            toast.dismiss()
        }
        
        clear()
        
    }
    
}
