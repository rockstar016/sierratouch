//
//  ScheduleModel.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

class ScheduleModel: AnyObject {
    var id:Int;
    var deviceid:Int;
    var dimmer_value:Int;
    var time_stamp:String;
    var ledonoff:Bool;
    var workday:String;
    
    init() {
        id = Int()
        deviceid = Int()
        dimmer_value = Int()
        time_stamp = String()
        ledonoff = Bool()
        workday = String()
    }
}
