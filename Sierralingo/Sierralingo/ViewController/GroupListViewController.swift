//
//  GroupListViewController.swift
//  Sierralingo
//
//  Created by Rock on 1/15/18.
//  Copyright © 2018 Rock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
class GroupListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tbGroupList: UICollectionView!
    var arraylist_devices:[GroupDevice] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        InitPushedController()
        arraylist_devices.removeAll();
        tbGroupList.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        sendServiceTouchGroup()
    }

    func sendServiceTouchGroup(){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Loading Group"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let device_type = Constants.DeviceType.TOUCH_DEVICE_TYPE
        
        
        Alamofire.request(Constants.RequestURL.GET_GROUP_DEVICE_LIST_URL, method: .get, parameters: ["id": user_id, "group_type": device_type], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! [NSDictionary]
                    for device in res{
                        let group_temp_device = GroupDevice()
                        group_temp_device.group_id = device.object(forKey: "id") as! String
                        group_temp_device.group_dim_value = Int(device.object(forKey: "dimmer_value") as! String)!
                        if(Int(group_temp_device.group_dim_value) < 10)
                        {
                            group_temp_device.group_dim_value = 10
                        }
                        
                        group_temp_device.group_name = device.object(forKey: "name") as! String
                        group_temp_device.group_touch_deivces = device.object(forKey: "devices") as! String
                        group_temp_device.group_led_state = (Int(device.object(forKey: "state") as! String)! == 1)
                        group_temp_device.group_led_status = (Int(device.object(forKey: "ledonoff") as! String)! == 1)
                        group_temp_device.voice_location = device.object(forKey: "voice_location") as! String
                        group_temp_device.voice_index = device.object(forKey: "voice_index") as! String
                        self.arraylist_devices.append(group_temp_device)
                    }
                    self.tbGroupList.reloadData()
                    break
                case .failure:
                    self.view.makeToast("Failed to load devices")
                    break
                }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraylist_devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ControlGroupNavController") as! UINavigationController
        let secondVC = navController.viewControllers.first as! GroupManipulateViewController
        secondVC.device = arraylist_devices[indexPath.row]
        self.present(navController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grouplistcell", for: indexPath) as! GroupListViewCell
        cell.setDataSource(arraylist_devices[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pic_dimension_width = tbGroupList.frame.size.width / 2 - 15;
        //        let pic_dimension_height = list_touch.frame.size.height / 3 - 20;
        return CGSize(width: pic_dimension_width, height: pic_dimension_width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    
    @IBAction func onClickAddGroup(_ sender: Any) {
        let group:GroupDevice = GroupDevice()
        group.group_dim_value = 0
        group.group_id = ""
        group.group_led_state = false
        group.group_led_status = false
        group.group_touch_deivces = ""
   
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "groupeditviewcontroller") as! EditGroupViewController
        secondViewController.group = group
        secondViewController.is_update = false
        self.present(secondViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func OnClickAdd(_ sender: Any)
    {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupNavController") as! UINavigationController
        let secondVC = navController.viewControllers.first as! EditGroupViewController
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func OnClickBack(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
}
