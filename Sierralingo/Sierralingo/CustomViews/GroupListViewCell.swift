//
//  GroupListViewCell.swift
//  Sierralingo
//
//  Created by Rock on 1/15/18.
//  Copyright © 2018 Rock. All rights reserved.
//

import UIKit
import UICircularProgressRing
class GroupListViewCell: UICollectionViewCell {
    @IBOutlet weak var txtDim: UILabel!
    
    @IBOutlet weak var circleProgress: UICircularProgressRingView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var imgTurnOnOff: UIImageView!
    func setDataSource(_ item:GroupDevice){
        self.txtName.text = item.group_name
        self.circleProgress.setProgress(value: CGFloat(item.group_dim_value), animationDuration: 1.0)
        self.imgTurnOnOff.image = item.group_led_state ? UIImage(named: "light_on") : UIImage(named: "light_off")
        self.txtDim.text = String.init(format: "%d %%", item.group_dim_value)
    }
}
