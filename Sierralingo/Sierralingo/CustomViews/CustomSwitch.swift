//
//  CustomSwitch.swift
//  Sierralingo
//
//  Created by Sobura on 3/20/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class CustomSwitch: UISwitch {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
}
