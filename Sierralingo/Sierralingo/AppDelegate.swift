//
//  AppDelegate.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Centime", size: 20)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        IQKeyboardManager.sharedManager().enable = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if WhenBack.sharedInstance.Key == true && Connection.isInternetAvailable() == true{
 
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = mainStoryboard.instantiateViewController(withIdentifier: "scandevice_controller") as! ScanDeviceViewController
            self.window?.rootViewController = secondViewController
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

