//
//  QueuePosition.swift
//  
//  Cheers
//  Copyright (C) 2021 Tim Fraedrich <tim@tadris.de>
//

import Foundation

/**
 An Enumeration describing where an element of `ToastQueue` should be added; `front` meaning it will be displayed immediately and `back` meaning it will be added as the last element to be displayed
 */
public enum QueuePosition {
    
    /// The toast will be placed at the front of the queue and displayed immediately
    case front
    /// The toast will be placed at the back of the queue and displayed after all other toasts in front of it were
    case back
    
}
