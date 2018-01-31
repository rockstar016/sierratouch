//
//  GroupEditCellView.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//
import UIKit
class GroupEditCell: UICollectionViewCell {
    
    @IBOutlet weak var chk_touch_device: CheckboxButton!
    @IBOutlet weak var txt_device_name: UILabel!
    func setDataSource(_ item:TouchDevice, _ selected:Bool){
        txt_device_name.text = item.device_location
        chk_touch_device.isChecked = selected
        print("******\(selected)")
    }
}
