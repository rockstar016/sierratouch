//
//  RoundWhiteButton.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
@IBDesignable
class RoundWhiteButton: UIButton {
    var selected_value: Bool = false
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(self, action: #selector(buttonTapUp(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonTapDown(_:)), for: .touchDown)
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = Constants.AppColors.White_Color;
        self.titleLabel?.textColor = UIColor.black;
    }
    
    func buttonTapUp(_ sender:UIButton){
        self.backgroundColor = Constants.AppColors.White_Color;
    }
    func buttonTapDown(_ sender:UIButton){
        self.backgroundColor = UIColor.lightGray;
    }
}
