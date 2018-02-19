//
//  ScanDeviceViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/7/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Foundation
import SystemConfiguration.CaptiveNetwork
import MBProgressHUD
class ScanDeviceViewController: UIViewController {

    @IBOutlet weak var label_comment: UILabel!
    var internetReachability = Reachability()
    var ssid:String = String()
    var isFirstDisply :  Bool = false
    
    func updateInterfaceWithReachability(reachability_noti: Notification)
    {
        let reach = reachability_noti.object as! Reachability
        let netStatus:Reachability.NetworkStatus = reach.currentReachabilityStatus
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        switch (netStatus)
        {
        case Reachability.NetworkStatus.notReachable:
            goToWiFiSetting()
            break
        case Reachability.NetworkStatus.reachableViaWWAN:
            goToWiFiSetting()
            break
        case Reachability.NetworkStatus.reachableViaWiFi:
//            DispWifiInformation()
            break
        }
    }
    
    func DispWifiInformation(){
       ssid = getWifiSsid()
        if ssid.isEmpty {
            ssid = "Unnamed"
        }
        label_comment.text = "You are currently connected to \"\(ssid)\" WI-FI network.Would you like to setup your TOUCH switch on this network ?"
        
    }
    
    func getWifiSsid()-> String{
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        if ssid == nil{
            
        }
        return ssid!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitPushedController()
        
        if WhenBack.sharedInstance.Key == true || isFirstDisply == true{
             WhenBack.sharedInstance.Key = false
             MBProgressHUD.showAdded(to: self.view, animated: true)
            NotificationCenter.default.addObserver(self, selector: #selector(updateInterfaceWithReachability), name: ReachabilityChangedNotification, object: internetReachability)
            do{
                try self.internetReachability?.startNotifier()
            }
            catch{
                print("error in ssid")
            }

        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        if WhenBack.sharedInstance.Key == true {
//           
//            MBProgressHUD.showAdded(to: view, animated: true)
//            NotificationCenter.default.addObserver(self, selector: #selector(updateInterfaceWithReachability), name: ReachabilityChangedNotification, object: internetReachability)
//            do{
//                try self.internetReachability?.startNotifier()
//            }
//            catch{
//                print("error in ssid")
//            }
//
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateInterfaceWithReachability), name: ReachabilityChangedNotification, object: internetReachability)
//        do{
//            try self.internetReachability?.startNotifier()
//        }
//        catch{
//            print("error in ssid")
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onClickBackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onClickYes(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toWiFiPasswordPage", sender: self)
        
//        secondViewController.txt_ssid_content = ssid
        

    }
    @IBAction func onClickNo(_ sender: Any) {
        goToWiFiSetting()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toWiFiPasswordPage")
        {
        }
    }
    
    func goToWiFiSetting(){
        
        self.performSegue(withIdentifier: "toWiFiSettingPage", sender: self)
    }
    deinit {
        stopNotifier()
    }
    func stopNotifier(){
        internetReachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        internetReachability = nil
    }
}
