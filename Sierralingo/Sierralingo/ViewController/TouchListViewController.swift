//
//  TouchListViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/2/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SystemConfiguration.CaptiveNetwork
class TouchListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var ssid:String = String()
    @IBOutlet weak var list_touch: UICollectionView!
    var arraylist_devices:[TouchDevice] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        InitPushedController()
        arraylist_devices.removeAll();
        list_touch.backgroundColor = UIColor.clear
        sendServiceTouchDevice()
    }
    
    func sendServiceTouchDevice(){
        //service for touch device
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Loading Device"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let device_type = Constants.DeviceType.TOUCH_DEVICE_TYPE
        
        
        Alamofire.request(Constants.RequestURL.GET_TOUCH_DEVICE_LIST_URL, method: .get, parameters: ["id": user_id, "device_type": device_type], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! [NSDictionary]
                    for device in res{
                        let touch_temp_device = TouchDevice()
                        touch_temp_device.device_id = device.object(forKey: "id") as! String
                        touch_temp_device.device_dim_value = Int(device.object(forKey: "dimmer_value") as! String)!
                        if(Int(touch_temp_device.device_dim_value) < 10)
                        {
                            touch_temp_device.device_dim_value = 10
                        }
                        touch_temp_device.device_property_name = device.object(forKey: "property_name") as! String
                        touch_temp_device.device_mac_id = device.object(forKey: "mac_id") as! String
                        touch_temp_device.device_location = device.object(forKey: "location_name") as! String
                        touch_temp_device.device_led_state = (Int(device.object(forKey: "state") as! String)! == 1)
                        touch_temp_device.device_led_status = (Int(device.object(forKey: "ledonoff") as! String)! == 1)
                        touch_temp_device.voice_location = device.object(forKey: "voice_location") as! String
                        touch_temp_device.voice_index = device.object(forKey: "voice_index") as! String
                        
                        self.arraylist_devices.append(touch_temp_device)
                    }
                    UIView.performWithoutAnimation {
                        self.list_touch.reloadData()
                    }
//                    self.list_touch.reloadData()
                    //self.sendServiceTouchGroup()
                    break
                case .failure:
                    break
                }
        }
        
        
        
    }
    
    //service for group device
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraylist_devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceNavController") as! UINavigationController
        let secondVC = navController.viewControllers.first as! DeviceManipulateViewController
        secondVC.device = arraylist_devices[indexPath.row]
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "touchlistcell", for: indexPath) as! TouchListCellView
        cell.setDataSource(arraylist_devices[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pic_dimension_width = list_touch.frame.size.width / 2 - 15;
        return CGSize(width: pic_dimension_width, height: pic_dimension_width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
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
            ssid = String()
        }
        return ssid!
    }
    
    @IBAction func onClickAddScene(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "scenelistcontroller") as! SceneListViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onClickAddTouchDevice(_ sender: Any) {
//        ssid = getWifiSsid()
//        if ssid.isEmpty
//        {
//            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "wifisetting_view") as! WifiSettingViewController
//            self.present(secondViewController, animated: true, completion: nil)
//
//        }
//        else
//        {
            let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanDeviceNavController") as! UINavigationController
            let secondVC = navController.viewControllers.first as! ScanDeviceViewController
            secondVC.isFirstDisply = true
            self.present(navController, animated: true, completion: nil)
            
//        }
    }
}
