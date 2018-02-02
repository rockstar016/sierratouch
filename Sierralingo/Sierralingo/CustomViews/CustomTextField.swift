//
//  customTextField.swift
//  Sierralingo
//
//  Created by Sobura on 1/2/2018.
//  Copyright © 2018 Rock. All rights reserved.
//

import UIKit

class CustomTextField: UITextField
{
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        if #available(iOS 10.0, *) {
            self.layer.borderColor = UIColor(displayP3Red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0).cgColor
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

