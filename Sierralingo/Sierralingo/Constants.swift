//
//  Constants.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//
import UIKit
struct Constants{
    struct AppColors{
        static let Gray_Color = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        static let White_Color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    struct ControlColor{
        static let Dark_Green_Color = UIColor(red: 165/255, green: 179/255, blue: 135/255, alpha:1.0)
        static let Green_Color = UIColor(red: 224/255, green: 236/255, blue: 99/255, alpha: 1.0)
    }
    
    struct RequestURL{
        static let BASE_URL = "http://sierralingo.com/modules/mobile/"
        static let LOGIN_URL = BASE_URL + "loginmobile.php"
        static let REGISTER_URL = BASE_URL + "registermobile.php"
        static let GET_TOUCH_DEVICE_LIST_URL = BASE_URL + "mobile-getdevicelist.php"
        static let GET_GROUP_DEVICE_LIST_URL = BASE_URL + "mobile-get-grouplist.php"
        static let UPDATE_TOUCH_DEVICE_URL = BASE_URL + "edit-touch-mobile.php"
        static let UPDATE_TOUCH_GROUP_URL = BASE_URL + "udpate-group-status-mobile.php"
        static let DELETE_TOUCH_GROUP_URL = BASE_URL + "mobile-del-group.php"
        static let EDIT_TOUCH_GROUP_URL = BASE_URL + "edit-group-mobile.php"
        static let ADD_TOUCH_GROUP_URL = BASE_URL + "add-group-touch-mobile.php"
        static let GET_SCHEDULE_URL = BASE_URL + "mobile-getschedule.php"
        static let REMOVE_SCHEDULE_URL = BASE_URL + "mobile-delschedule.php"
        static let UPDATE_SCHEDULE_URL = BASE_URL + "edit-schedule-mobile.php"
        static let ADD_SCHEDULE_URL = BASE_URL + "add-schedule-touch-mobile.php"
        static let GET_SCENE_URL = BASE_URL + "mobile-getscene.php"
        static let REMOVE_SCENE_URL = BASE_URL + "mobile-delscene.php"
        static let UPDATE_SCENE_TURN_URL = BASE_URL + "update_scene_turn.php"
        static let EDIT_SCENE_URL = BASE_URL + "edit-scene-mobile.php"
        static let ADD_SCENE_URL = BASE_URL + "add-scene-touch-mobile.php"
        static let ADD_TOUCH_URL = BASE_URL + "add-device-touch-mobile.php"
    }
    struct ResponseResult{
        static let SUCCESS_KEY = 1;
        static let FAILED_KEY = 0;
    }
    
    struct DeviceType{
        static let TOUCH_DEVICE_TYPE = 0;
    }
}
