//
//  DeviceManipulateViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/3/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MLVerticalProgressView
import MBProgressHUD
import Alamofire
class DeviceManipulateViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var vertical_progress: VerticalProgressView!
    @IBOutlet weak var bt_schedule: RoundGreenButton!
    @IBOutlet weak var bt_save_changes: RoundGreenButton!
    @IBOutlet weak var img_state: UIImageView!
    @IBOutlet weak var txt_device_location: UILabel!
    @IBOutlet weak var switch_status: UISwitch!
    @IBOutlet weak var view_advanced: UIView!
    @IBOutlet weak var bt_advanced: RoundGreenButton!
    @IBOutlet weak var controller_view: UIView!
    
    var device:TouchDevice = TouchDevice()
    override func viewDidLoad() {
        super.viewDidLoad()
        vertical_progress.fillDoneColor = Constants.ControlColor.Dark_Green_Color
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStatementImageView(_sender:)))
        tap.delegate = self;
        img_state.isUserInteractionEnabled = true
        img_state.addGestureRecognizer(tap)
        
        initAllUIBasedOnDevice()
    }

    func initAllUIBasedOnDevice(){
        vertical_progress.setProgress(progress: Float(device.device_dim_value)/100.0, animated: true)
        if(device.device_led_state){
            img_state.image = UIImage(named:"device_touch_status_on")
        }
        else{
            img_state.image = UIImage(named:"device_touch_status_off")
        }
        switch_status.isOn = device.device_led_status
        txt_device_location.text = device.device_location
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bt_advanced.selected_value = false
        showHideAdvancedView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProgressBar(_sender:)))
        vertical_progress.addGestureRecognizer(tap)
        vertical_progress.isUserInteractionEnabled = true
        vertical_progress.fillDoneColor = Constants.ControlColor.Dark_Green_Color
    }
    
    func handleStatementImageView(_sender:UIImageView){
        device.device_led_state = !device.device_led_state
        if(device.device_led_state){
            img_state.image = UIImage(named:"device_touch_status_on")
        }
        else{
            img_state.image = UIImage(named:"device_touch_status_off")
        }
    }
    
    func handleProgressBar(_sender:UITapGestureRecognizer){
         let touchPoint = _sender.location(in: self.vertical_progress)
         var current_percentage = (1 - touchPoint.y / (self.vertical_progress.frame.height - 3))
        if(current_percentage < 0.1){
            current_percentage = 0.1;
        }
         vertical_progress.setProgress(progress: Float(current_percentage), animated: true)
    }
    
    
    func showHideAdvancedView(){
        if(bt_advanced.selected_value == false){
            
            bt_save_changes.frame =   CGRect(x:view_advanced.frame.origin.x, y:view_advanced.frame.origin.y + 5, width:view_advanced.frame.size.width, height:35);
            bt_schedule.frame =   CGRect( x:bt_save_changes.frame.origin.x, y:(bt_save_changes.frame.origin.y + bt_save_changes.frame.size.height + 5), width:bt_save_changes.frame.size.width, height:35);
            view_advanced.isHidden = true;
            bt_advanced.setTitle("Advanced>>", for: .normal)
        }
        else{
            
            bt_save_changes.frame =   CGRect(x:view_advanced.frame.origin.x, y:view_advanced.frame.origin.y+view_advanced.frame.size.height+5, width:view_advanced.frame.size.width, height:35);
            bt_schedule.frame =   CGRect(x:bt_save_changes.frame.origin.x, y:bt_save_changes.frame.origin.y + 5 + bt_save_changes.frame.size.height, width:bt_save_changes.frame.size.width, height:35);
            view_advanced.isHidden = false;
            bt_advanced.setTitle("Advanced<<", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBackButton(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "touchListActivity") as! TouchListViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func OnClickAdvancedButton(_ sender: RoundGreenButton) {
        bt_advanced.selected_value = !bt_advanced.selected_value
        showHideAdvancedView()
    }
    
    
    @IBAction func onClickSaveChanges(_ sender: RoundGreenButton) {
        
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Update Device"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let dim_value = String.init(format: "%d", Int(vertical_progress.progress*100))
        let led_status:Int = switch_status.isOn ? 1 : 0
        let led_state:Int = device.device_led_state ? 1 : 0
        let voice_location = device.voice_location
        let voice_index = device.voice_index
        let device_location = device.device_location;
        let device_property = device.device_property_name;
        
        Alamofire.request(Constants.RequestURL.UPDATE_TOUCH_DEVICE_URL, method: .get, parameters: ["id":user_id,  "device_id":device.device_id, "dim":dim_value, "led_state":led_status, "state":led_state,
        "voice_location":voice_location, "voice_index":voice_index, "device_location":device_location, "device_property":device_property], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    print(res)
                    let result = res.object(forKey: "success") as! Int
                    if result == Constants.ResponseResult.SUCCESS_KEY{
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "touchListActivity") as! TouchListViewController
                        self.present(secondViewController, animated: true, completion: nil)
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
    
    @IBAction func bt_dim_up(_ sender: Any) {
        var progress_value = vertical_progress.progress + 0.1
        if progress_value > 1{
            progress_value = 1
        }
        vertical_progress.setProgress(progress: progress_value, animated: true)
    }
    
    @IBAction func bt_dim_down(_ sender: Any) {
        var progress_value = vertical_progress.progress - 0.1
        if progress_value < 0.1 {
            progress_value = 0.1
        }
        vertical_progress.setProgress(progress: progress_value, animated: true)
    }
    @IBAction func onClickSchedule(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "schedulelistview") as! ScheduleListViewController
        secondViewController.touch_device = device
        self.present(secondViewController, animated: true, completion: nil)
    }
}
