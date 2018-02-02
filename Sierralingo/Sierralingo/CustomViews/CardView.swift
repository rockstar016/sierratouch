//
//  CardView.swift
//  Sierralingo
//
//  Created by Rock on 3/6/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
@IBDesignable
class CardView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width: -1, height:1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width:-1, height:1)
        
    }
}
