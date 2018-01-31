//
//  SceneModel.swift
//  Sierralingo
//
//  Created by Rock on 3/6/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
class SceneModel{
    var devices:String
    var turnvalue:String
    var dimvalue:String
    var scene_name:String
    var id:Int
    var owner_id:String
    var scene_turn:Int
    init() {
        devices = String()
        turnvalue = String()
        dimvalue = String()
        scene_name = String()
        id = Int()
        owner_id = String()
        scene_turn = Int()
    }
}
