//
//  TouchListCellView.swift
//  Sierralingo
//
//  Created by Rock on 3/2/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import UICircularProgressRing
class TouchListCellView: UICollectionViewCell {

    @IBOutlet weak var txtName: UILabel!
   
    @IBOutlet weak var circleProgress: UICircularProgressRingView!
    @IBOutlet weak var imgOnOff: UIImageView!
    @IBOutlet weak var txtDimValue: UILabel!
    func setDataSource(_ item:TouchDevice){
        txtName.text = item.device_location
        circleProgress.setProgress(value: CGFloat(item.device_dim_value), animationDuration: 1.0)
        imgOnOff.image = item.device_led_state ? UIImage(named: "light_on") : UIImage(named: "light_off")
        txtDimValue.text = String.init(format: "%d %%", item.device_dim_value)
    }
}
