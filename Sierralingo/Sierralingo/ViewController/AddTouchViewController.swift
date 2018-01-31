//
//  AddTouchViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/8/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
class AddTouchViewController: UIViewController {
    @IBOutlet weak var txt_property_name: UITextField!
    
    
    @IBOutlet weak var txt_mac_id: UITextField!
    @IBOutlet weak var txt_device_location: UITextField!
    var mac_id:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_mac_id.text = mac_id
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickBackButton(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "scandevice_controller") as! ScanDeviceViewController
        self.present(secondViewController, animated: true, completion: nil)

    }
    @IBAction func onClickAddButton(_ sender: Any) {
        if (txt_mac_id.text?.isEmpty)!{
            self.view.makeToast("Enter the mac id, please")
            return
        }
        if (txt_property_name.text?.isEmpty)!{
            self.view.makeToast("Enter the property name, please")
            return
        }
        if (txt_device_location.text?.isEmpty)!{
            self.view.makeToast("Enter the location, please")
            return
        }
        
        
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Adding Touch"
        
        var location:String = txt_device_location.text!
        location = location.replacingOccurrences(of: " ", with: "_")
        var property_name:String = txt_property_name.text!
        property_name = property_name.replacingOccurrences(of: " ", with: "_")
        var mac_id:String = txt_device_location.text!
        mac_id = mac_id.replacingOccurrences(of: " ", with: "_")
        let user_id:String = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        
        Alamofire.request(Constants.RequestURL.ADD_TOUCH_URL, method: .get, parameters: ["location":location, "name":property_name,"macid":mac_id, "id":user_id, "voice_location":"", "voice_index":""], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    let success_value = res.object(forKey: "success") as! NSInteger
                    if(success_value == Constants.ResponseResult.SUCCESS_KEY){
                        
                        let device_id = res.object(forKey: "device_id")
                        let temp_device:TouchDevice = TouchDevice()
                        temp_device.device_id = device_id as! String
                        temp_device.device_location = self.txt_device_location.text!
                        temp_device.device_property_name = self.txt_property_name.text!
                        temp_device.device_led_state = false
                        temp_device.device_led_status = false
                        temp_device.device_dim_value = 0
                        
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "devicemanipulate") as! DeviceManipulateViewController
                        secondViewController.device = temp_device
                        self.present(secondViewController, animated: true, completion: nil)
                    }
                    else{
                        self.view.makeToast("Failed to create touch. Try again")
                    }
                    break
                case .failure:
                    break
                }
        }
    }
}
