//
//  DayButton.swift
//  Sierralingo
//
//  Created by Rock on 3/5/17.
//  Copyright © 2017 Rock. All rights reserved.
//
import UIKit
@available(iOS 10.0, *)
@IBDesignable
class DayButton: UIButton {
    @IBInspectable
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                    self.backgroundColor = UIColor(displayP3Red: 182/255, green: 200/255, blue: 40/255, alpha: 1.0)
                    // Fallback on earlier versions
                self.setTitleColor(UIColor.white, for: .normal)
            } else {
                self.backgroundColor = UIColor(displayP3Red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
                self.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 3
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.cornerRadius = 3
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    func buttonClicked(_ sender:DayButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }
}

