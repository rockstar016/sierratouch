//
//  SceneListViewCell.swift
//  Sierralingo
//
//  Created by Rock on 3/6/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit



class SceneListViewCell: UITableViewCell {

    @IBOutlet weak var toggleOnOff: BulbOnOffButton!
    
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var txtLocation: UILabel!
    override func awakeFromNib() {
       super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDataSource(_ source:SceneModel){
        txtLocation.textColor = Constants.ControlColor.Dark_Green_Color
        txtLocation.text = source.scene_name
        toggleOnOff.isChecked = source.scene_turn==1
        let device = source.devices.components(separatedBy: "|")
        txtNumber.textColor = Constants.ControlColor.Dark_Green_Color
        txtNumber.text = "\(device.count)"
    }
}
