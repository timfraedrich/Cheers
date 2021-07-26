//
//  TextToast.swift
//
//  Cheers
//  Copyright (C) 2021 Tim Fraedrich <tim@tadris.de>
//

import UIKit
import SnapKit

/**
 `TextBanner` is a subclass of `BaseToast` and simply just shows a label with specified text, much like an alert
 */
public class TextToast: BaseToast {
    
    /**
     Initialises a `BaseToast` with a simple label
     */
    public init(text: String, font: UIFont? = nil, isDismissable: Bool = true) {
        
        super.init(customise: { (toast, contentView) in
            
            let label = UILabel()
            
            label.font = font ?? label.font
            label.text = text
            label.numberOfLines = 0
            
            contentView.addSubview(label)
            
            label.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
        }, isDismissable: isDismissable)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
