//
//  EditGroupViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class EditGroupViewController: UIViewController, UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var devices = [TouchDevice]()
    var group:GroupDevice = GroupDevice()
    var selection_list = [Bool]()
    var is_update:Bool = false;
    @IBOutlet weak var device_list: UICollectionView!
    @IBOutlet weak var txt_group_name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        InitPushedController()
        sendServiceTouchDevice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sendServiceTouchDevice(){
        //service for touch device
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Loading Device"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let device_type = Constants.DeviceType.TOUCH_DEVICE_TYPE
        devices.removeAll()
        Alamofire.request(Constants.RequestURL.GET_TOUCH_DEVICE_LIST_URL, method: .get, parameters: ["id": user_id, "device_type": device_type], encoding: URLEncoding.default, headers: nil).responseJSON
            {
                response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! [NSDictionary]
                    for device in res
                    {
                        let touch_temp_device = TouchDevice()
                        touch_temp_device.device_id = device.object(forKey: "id") as! String
                        touch_temp_device.device_dim_value = Int(device.object(forKey: "dimmer_value") as! String)!
                        touch_temp_device.device_property_name = device.object(forKey: "property_name") as! String
                        touch_temp_device.device_mac_id = device.object(forKey: "mac_id") as! String
                        touch_temp_device.device_location = device.object(forKey: "location_name") as! String
                        touch_temp_device.device_led_state = (Int(device.object(forKey: "state") as! String)! == 1)
                        touch_temp_device.device_led_status = (Int(device.object(forKey: "ledonoff") as! String)! == 1)
                        self.devices.append(touch_temp_device)
                    }
                    self.updateCollectionView()

                    break
                case .failure:
                    self.view.makeToast("Failed to load group. Try again")
                    break
                }
        }
    }

    func updateCollectionView(){
        if devices.count == 0 {
            return
        }
        for i:Int in 0...devices.count-1
        {
            if group.group_touch_deivces.contains(devices[i].device_id){
                selection_list.append(true)
            }
            else{
                selection_list.append(false)
            }
        }
        txt_group_name.text = group.group_name
        device_list.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection_list[indexPath.row] = !selection_list[indexPath.row]
        device_list.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupeditcell", for: indexPath) as! GroupEditCell
        cell.chk_touch_device.tag = indexPath.row
        cell.chk_touch_device.addTarget(self, action: #selector(self.onClickItem(_:)), for: .touchUpInside)
        cell.setDataSource(devices[indexPath.row], selection_list[indexPath.row])
        return cell
    }
    
    func onClickItem(_ sender:CheckboxButton){
        selection_list[sender.tag] = sender.isChecked
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pic_dimension_width = device_list.frame.size.width - 10;
        let pic_dimension_height = CGFloat(35)
        return CGSize(width: pic_dimension_width, height: pic_dimension_height)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if(is_update == true){
//            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupmanipulate") as! GroupManipulateViewController
//            secondViewController.device = group
//            self.present(secondViewController, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "touchListActivity") as! TouchListViewController
            self.present(secondViewController, animated: true, completion: nil)
        }
    }

    @IBAction func onClickCancel(_ sender: Any) {
        if(is_update == true){
//            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupmanipulate") as! GroupManipulateViewController
//            secondViewController.device = group
//            self.present(secondViewController, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }

    }
/*
     * Update group
     *
*/
    @IBAction func onClickDone(_ sender: Any) {
        
        var selected_device:String = ""
//        for i in 0...devices.count-1{
//            if(selection_list[i] == true){
//                selected_device += devices[i].device_id + "|"
//            }
//        }
        if(selected_device.count > 1){
            let index = selected_device.index(selected_device.startIndex, offsetBy: selected_device.count-1)
            selected_device = selected_device.substring(to: index)
        }
        var group_name:String = txt_group_name.text!
        group_name = group_name.replacingOccurrences(of: " ", with: "_")
        if(group_name.isEmpty == false){
            if(is_update == true){
                self.updateGroupDevice(group_name: group_name, selectionlist: selected_device)
            }
            else{
                self.createNewGroup(group_name: group_name, selectionlist: selected_device)
            }
        }
        else{
            self.view.makeToast("Enter the group name, please")
        }
    }
    
    func createNewGroup(group_name:String, selectionlist devices:String){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Create Group"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        
        
        Alamofire.request(Constants.RequestURL.ADD_TOUCH_GROUP_URL, method: .get, parameters: ["name":group_name,  "devices":devices, "id":user_id,"voice_location":"", "voice_index":""], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    let result = res.object(forKey: "success") as! Int
                    if result == Constants.ResponseResult.SUCCESS_KEY{
//                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "touchListActivity") as! TouchListViewController
//                        self.present(secondViewController, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.view.makeToast("Failed to create. Try again")
                    }
                    
                    break
                case .failure:
                    self.view.makeToast("Failed to create. Try again")
                    break
                }
        }
    }
    
    func updateGroupDevice(group_name:String, selectionlist selected_device:String){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Update Group"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        
        group.group_name = group_name
        group.group_touch_deivces = selected_device
        let voice_location = group.voice_location
        let voice_index = group.voice_index
        
        Alamofire.request(Constants.RequestURL.EDIT_TOUCH_GROUP_URL, method: .get, parameters: ["name":group_name,  "devices":selected_device, "user_id":user_id, "id":group.group_id, "voice_location":voice_location,  "voice_index":voice_index], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    let result = Int(res.object(forKey: "success") as! String)!
                    if result == Constants.ResponseResult.SUCCESS_KEY{
                        
//                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupmanipulate") as! GroupManipulateViewController
//                        secondViewController.device = self.group
//                        self.present(secondViewController, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.view.makeToast("Failed to update. Try again")
                    }
                    
                    break
                case .failure:
                    self.view.makeToast("Failed to update. Try again")
                    break
                }
        }
    }
}
