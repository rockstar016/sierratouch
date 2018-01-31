//
//  TouchModel.swift
//  Sierralingo
//
//  Created by Rock on 3/2/17.
//  Copyright © 2017 Rock. All rights reserved.
//

class TouchModel: AnyObject {
    static let TOUCH_DEVICE = 0
    static let TOUCH_GROUP = 1
    var type:Int
    var touchDevice:TouchDevice
    var groupDevice:GroupDevice
    init() {
        type = -1
        touchDevice = TouchDevice()
        groupDevice = GroupDevice()
    }
}
