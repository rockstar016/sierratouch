//
//  BackgroundPanel.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class BackgroundPanel: UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5;
        self.backgroundColor = Constants.AppColors.Gray_Color;
    }
}
