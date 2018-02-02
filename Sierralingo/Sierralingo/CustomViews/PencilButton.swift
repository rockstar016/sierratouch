//
//  PencilButton.swift
//  Sierralingo
//
//  Created by Sobura on 1/2/2018.
//  Copyright © 2018 Rock. All rights reserved.
//
import UIKit

class PencilButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_gray")! as UIImage
    let uncheckedImage = UIImage(named: "ic_edit_gray")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
//                self.tintColor = Constants.ControlColor.Dark_Green_Color
            } else {
                self.setImage(uncheckedImage, for: .normal)
//                self.tintColor = Constants.ControlColor.Dark_Green_Color
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    func buttonClicked(_ sender:CheckboxButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }
}

