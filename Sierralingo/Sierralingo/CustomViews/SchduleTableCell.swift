//
//  SchduleTableCell.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class SchduleTableCell: UITableViewCell {

    @IBOutlet weak var content_view: UIView!
    @IBOutlet var day_labels: [DayLabel]!
    @IBOutlet weak var bt_remove: UIButton!
    @IBOutlet weak var bt_edit: UIButton!
    @IBOutlet weak var txt_dim_value: UILabel!
    @IBOutlet weak var switch_light_status: UISwitch!
    @IBOutlet weak var txt_am_pm: UILabel!
    @IBOutlet weak var txt_time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataSource(_ source:ScheduleModel)
    {
        switch_light_status.isOn = source.ledonoff
        let arr_time = source.time_stamp.components(separatedBy: ":")
        txt_time.text = arr_time[0] + ":" + arr_time[1]// String(format: "%s:%s", arr_time[0], arr_time[1])
        txt_am_pm.text = arr_time[2]
        
        txt_dim_value.text = String(format:"%d", source.dimmer_value)
        
        for i in 0...6{
            day_labels[i].isChecked = source.workday.contains(String(format: "%d",i))
        }
    }

}
