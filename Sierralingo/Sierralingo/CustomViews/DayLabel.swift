//
//  DayLabel.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class DayLabel: UILabel {

    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.textColor = Constants.ControlColor.Dark_Green_Color
            } else {
                self.textColor = UIColor.gray
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isChecked = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.isChecked = false
    }
}
