//
//  SceneEditViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/7/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import Toast_Swift
class SceneEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemEditProtocol {

    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var txt_scene_name: UITextField!
    @IBOutlet weak var navigation_item: UINavigationItem!
    
    @IBOutlet weak var btDoneDelete: UIButton!
    @IBOutlet weak var switch_light_onoff: CustomSwitch!
    var devices:[TouchDevice] = [TouchDevice]()
    var scene_model:SceneModel = SceneModel()
    var selection_list:[Bool] = [Bool]()
    var is_update:Bool = false
    var is_deleted:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitPushedController()
        if(is_update == true)
        {
//            navigation_item.title = "Edit Scene"
            btDoneDelete.setTitle("Delete", for: .normal)
            
        }
        else
        {
//            navigation_item.title = "Add Scene"
            btDoneDelete.setTitle("Done", for: .normal)
        }
//        switch_light_onoff.setOn(scene_model.scene_turn == 1, animated: false)
        sendServiceTouchDevice()
        
    }

    @IBAction func onClickBack(_ sender: Any)
    {
        goBackToPrevView()
    }
    
    @IBAction func TurnOnOffSceneSwitch(_ sender: CustomSwitch) {
        
        if(is_update)
        {
            let scene_id = scene_model.id
            let sw_value = switch_light_onoff.isOn == true ? 1 : 0
            
            Alamofire.request(Constants.RequestURL.UPDATE_SCENE_TURN_URL, method: .get, parameters: ["id": scene_id, "turnvalue":sw_value], encoding: URLEncoding.default, headers: nil).responseJSON
                {
                    response  in
                    switch (response.result)
                    {
                        case .success( _):
                            break
                        case .failure:
                            self.view.makeToast("Failed to udpate scene. Try again")
                            break
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    func clickRemoveButton(){
        // make confirm alert here
        let alert = UIAlertController(title: "Confirm", message: "Really want to remove this scene?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            self.sendDeleteService()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendDeleteService()
    {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Removing Scene"
        let scene_id = scene_model.id
        
        Alamofire.request(Constants.RequestURL.REMOVE_SCENE_URL, method: .get, parameters: ["id": scene_id], encoding: URLEncoding.default, headers: nil).responseJSON
            {
                response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                    case .success(let JSON):
                        let res = JSON as! NSDictionary
                        let result = res.object(forKey: "success") as! Int
                        if result == Constants.ResponseResult.SUCCESS_KEY
                        {
                            self.is_deleted = true
                            self.goBackToPrevView()
                        }
                        else
                        {
                            self.view.makeToast("Failed to remove scene. Try again")
                        }
                    
                        break
                    case .failure:
                        self.view.makeToast("Failed to remove scene. Try again")
                        break
                }
            }
    }

    
    func updateCollectionView(){
        if is_update
        {
            //var members_array = scene_model.devices.components(separatedBy: "|")
            var members_array = scene_model.devices.characters.split{$0 == "|"}.map(String.init)
            var status_array = scene_model.turnvalue.characters.split{$0 == "|"}.map(String.init)
            var dim_array = scene_model.dimvalue.characters.split{$0 == "|"}.map(String.init)
            
            selection_list.removeAll()
//            for i in 0...devices.count - 1 {
//                selection_list.append(false)
//                devices[i].device_led_status = false
//                devices[i].device_dim_value = 0
//                if(members_array.count > 0)
//                {
//                    for j in 0...members_array.count-1{
//                        if Int(devices[i].device_id) == Int(members_array[j]) {
//                            selection_list[i] = true;
//                            devices[i].device_led_status = Int(status_array[j]) == 1 ? true : false
//                            devices[i].device_dim_value = Int(dim_array[j])!
//                        }
//                    }
//                }
//            }
            txt_scene_name.text = scene_model.scene_name
        }
        else{
            selection_list.removeAll()
//            for i in 0...devices.count-1 {
//                selection_list.append(false)
//                devices[i].device_led_status = false
//                devices[i].device_dim_value = 0
//            }
        }
        table_view.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scene_table_item", for: indexPath) as! SceneModifyItemView
        cell.bt_chk_device.tag = indexPath.row
        cell.slider_dim_val.tag = indexPath.row
        cell.switch_status.tag = indexPath.row
        
        cell.setDataSource(touchDevice: devices[indexPath.row], selected: selection_list[indexPath.row])
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        let devices_list = self.getDevicesList()
        let turnvalue = self.getTurnValues()
        let dimvalue = self.getDimValues()
        let scene_name = self.getSceneNames()
        if(scene_name.isEmpty == false){
            if is_update {
                // delete
                clickRemoveButton()
            }
            else{
                self.addService(devices_list: devices_list, dimvalue: dimvalue, turnvalue:turnvalue, scene_name:scene_name)
            }
        }
        else{
            self.view.makeToast("Enter the scene name, please")
        }
    }
    
    func goBackToPrevView(){
        if(!(is_deleted && is_update))
        {
            let devices_list = self.getDevicesList()
            let turnvalue = self.getTurnValues()
            let dimvalue = self.getDimValues()
            let scene_name = self.getSceneNames()
            self.updateService(devices_list: devices_list, dimvalue: dimvalue, turnvalue:turnvalue, scene_name:scene_name)
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateService(devices_list:String, dimvalue:String, turnvalue:String, scene_name:String)
    {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "update Scene"
            Alamofire.request(Constants.RequestURL.EDIT_SCENE_URL, method: .get, parameters: ["id": scene_model.id, "devices":devices_list, "turnvalue":turnvalue, "dimvalue":dimvalue, "scene_name":scene_name], encoding: URLEncoding.default, headers: nil).responseJSON
                {
                    response  in
                    prog.hide(animated: true)
                    switch (response.result)
                    {
                        case .success( _):
                            self.dismiss(animated: true, completion: nil)
                            break
                        case .failure:
                            self.view.makeToast("Failed to udpate scene. Try again")
                            break
                    }
                }
    }
    
    func addService(devices_list:String, dimvalue:String, turnvalue:String, scene_name:String){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "create Scene"
        
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        Alamofire.request(Constants.RequestURL.ADD_SCENE_URL, method: .get, parameters: ["owner_id": user_id, "devices":devices_list, "ledonoff":turnvalue, "dim":dimvalue, "scene_name":scene_name], encoding: URLEncoding.default, headers: nil).responseJSON
            {
                response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                    case .success( _):
                        
                        self.goBackToPrevView()
                        break
                    case .failure:
                        self.view.makeToast("Failed to create scene. Try again")
                        break
                }
            }
    }
    
    
    func getDevicesList() -> String {
        var selected_device:String = ""
//        for i in 0...devices.count-1{
//            if(selection_list[i] == true){
//                selected_device += devices[i].device_id + "|"
//            }
//        }
//        if(selected_device.characters.count > 1){
//            let index = selected_device.index(selected_device.startIndex, offsetBy: selected_device.characters.count-1)
//            selected_device = selected_device.substring(to: index)
//        }
        return selected_device
    }
    
    func getTurnValues() -> String{
        var turn_device:String = ""
//        for i in 0...devices.count-1{
//            if(selection_list[i] == true){
//                let status = devices[i].device_led_status == true ? "1" : "0"
//                turn_device += status + "|"
//            }
//        }
//        if(turn_device.characters.count > 1){
//            let index = turn_device.index(turn_device.startIndex, offsetBy: turn_device.characters.count-1)
//            turn_device = turn_device.substring(to: index)
//        }
        return turn_device
    }
    
    func getDimValues() -> String{
        var dim_device:String = ""
//        for i in 0...devices.count-1{
//            if(selection_list[i] == true){
//                dim_device += String.init(format: "%d|", devices[i].device_dim_value)
//            }
//        }
//        if(dim_device.characters.count > 1){
//            let index = dim_device.index(dim_device.startIndex, offsetBy: dim_device.characters.count-1)
//            dim_device = dim_device.substring(to: index)
//        }
        return dim_device
    }
    
    func getSceneNames() -> String{
        let current_value = txt_scene_name.text
        let scene_name = current_value?.replacingOccurrences(of: " ", with: "_")
        return scene_name!
    }
    /**
    *  Protocols for item edit
    *
    **/
    func onEditCheckBox(index: Int, value: Bool) {
        selection_list[index] = value
    }
    
    func onChangeSwitch(index: Int, value: Bool) {
        devices[index].device_led_status = value
    }
    
    func onChangeSliderValue(index: Int, value: Int) {
        devices[index].device_dim_value = value
    }
}
