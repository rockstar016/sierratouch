//
//  RoundGreenButton.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class RoundGreenButton: UIButton {
    var selected_value: Bool = false
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(self, action: #selector(buttonTapUp(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonTapDown(_:)), for: .touchDown)
        self.layer.cornerRadius = 5;
        self.backgroundColor = Constants.ControlColor.Dark_Green_Color;
        self.titleLabel?.textColor = Constants.AppColors.White_Color;
    }
    
    func buttonTapUp(_ sender:UIButton){
        self.backgroundColor = Constants.ControlColor.Dark_Green_Color;
    }
    func buttonTapDown(_ sender:UIButton){
        self.backgroundColor = Constants.ControlColor.Green_Color;
    }
}
