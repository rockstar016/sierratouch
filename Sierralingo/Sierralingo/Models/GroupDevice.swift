//
//  GroupDevice.swift
//  Sierralingo
//
//  Created by Rock on 3/2/17.
//  Copyright © 2017 Rock. All rights reserved.
//

class GroupDevice: AnyObject {
    var group_id:String
    var group_name:String, group_touch_deivces:String
    var group_led_status:Bool, group_led_state:Bool
    var group_dim_value:Int
    var voice_location:String
    var voice_index:String
    init() {
        group_id = String()
        group_name = String()
        group_touch_deivces = String()
        group_led_status = Bool()
        group_led_state = Bool()
        group_dim_value = 0
        voice_location = String()
        voice_index = String()
    }
}
