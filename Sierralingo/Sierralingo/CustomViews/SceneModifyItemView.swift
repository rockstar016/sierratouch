//
//  SceneModifyItemView.swift
//  Sierralingo
//
//  Created by Rock on 3/7/17.
//  Copyright © 2017 Rock. All rights reserved.
//
import UIKit
protocol ItemEditProtocol {
    func onEditCheckBox(index:Int, value:Bool)
    func onChangeSwitch(index:Int, value:Bool)
    func onChangeSliderValue(index:Int, value:Int)
}

class SceneModifyItemView:UITableViewCell {
    @IBOutlet weak var slider_dim_val: UISlider!
  
    @IBOutlet weak var txt_dim_val: UILabel!
    @IBOutlet weak var switch_status: UISwitch!
    @IBOutlet weak var txt_device_name: UILabel!
    @IBOutlet weak var bt_chk_device: CheckboxButton!
    
    
    var delegate:ItemEditProtocol?
    func setDataSource(touchDevice:TouchDevice, selected:Bool){
        bt_chk_device.isChecked = selected
        txt_device_name.text = touchDevice.device_location
        switch_status.isOn =  touchDevice.device_led_status
        slider_dim_val.value = Float(touchDevice.device_dim_value)
        txt_dim_val.text = String.init(format: "%d", touchDevice.device_dim_value)
    }
    
    
    
    @IBAction func onChangeSliderValue(_ sender: UISlider) {
        let current_value = Int(sender.value)
        DispatchQueue.main.async {
            self.txt_dim_val.text = "\(current_value)"
        }
        
        delegate?.onChangeSliderValue(index: sender.tag, value: current_value)
    }
    
    @IBAction func onChangeCheckbox(_ sender: CheckboxButton) {
        delegate?.onEditCheckBox(index: sender.tag, value: sender.isChecked)
    }
    
    @IBAction func onChangeSwitchValue(_ sender: UISwitch) {
        delegate?.onChangeSwitch(index: sender.tag, value: sender.isOn)
    }
}
