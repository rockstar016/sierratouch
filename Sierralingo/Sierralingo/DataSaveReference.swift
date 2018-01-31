//
//  DataSaveReference.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
public class DataSaveReference{
    public static let USER_PASSWORD_SHOW = "password_show"
    public static let USER_AUTO_LOGIN = "auto_login"
    public static let USER_EMAIL = "email"
    public static let USER_PASSWORD = "password"
    public static let USER_ID = "userid"
    public static func saveBoolData(value:Bool, key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func readBoolData(key:String)->Bool{
        let value = UserDefaults.standard.bool(forKey: key)
        return value;
    }
    
    public static func saveStringData(value:String, key:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func readStringData(key:String)->String{
        var value = UserDefaults.standard.string(forKey: key)
        if value == nil {
            value = String()
        }
        return (value)!;
    }
}
