//
//  TouchDevice.swift
//  Sierralingo
//
//  Created by Rock on 3/2/17.
//  Copyright © 2017 Rock. All rights reserved.
//

class TouchDevice: AnyObject {
    var device_id:String
    var device_mac_id:String, device_location:String, device_property_name:String;
    var device_led_status:Bool, device_led_state:Bool;
    var device_dim_value:Int;
    var voice_location:String, voice_index:String;
    init() {
        device_id = String()
        device_mac_id = String()
        device_location = String()
        device_property_name = String()
        device_led_state = Bool()
        device_led_status = Bool()
        device_dim_value = 0
        voice_location = String()
        voice_index = String()
    }
}
