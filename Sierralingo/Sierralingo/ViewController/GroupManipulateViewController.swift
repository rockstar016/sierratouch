//
//  GroupManipulateViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MLVerticalProgressView
import MBProgressHUD
import Alamofire
import NVActivityIndicatorView
class GroupManipulateViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var recView: UIView!
    @IBOutlet weak var bt_edit_group: RoundGreenButton!
    @IBOutlet weak var bt_save_changes: RoundGreenButton!
    @IBOutlet weak var view_advanced: UIView!
    @IBOutlet weak var vertical_progress: VerticalProgressView!
    
    @IBOutlet weak var bt_advanced: RoundGreenButton!
    @IBOutlet weak var switch_status: UISwitch!
    @IBOutlet weak var img_state: UIImageView!
    @IBOutlet weak var txt_group_name: UILabel!
    var device:GroupDevice = GroupDevice()
    var loadingAcitivity:NVActivityIndicatorView?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitPushedController()
        vertical_progress.fillDoneColor = Constants.ControlColor.Dark_Green_Color
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStatementImageView(_sender:)))
        tap.delegate = self;
        img_state.isUserInteractionEnabled = true
        img_state.addGestureRecognizer(tap)
        
        initAllUIBasedOnDevice()
    }

    func handleStatementImageView(_sender:UIImageView){
        device.group_led_state = !device.group_led_state
        if(device.group_led_state){
            img_state.image = UIImage(named:"device_touch_status_on")
        }
        else{
            img_state.image = UIImage(named:"device_touch_status_off")
        }
    }

    
    @IBAction func onClickDelete(_ sender: Any) {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Delete Group"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        Alamofire.request(Constants.RequestURL.DELETE_TOUCH_GROUP_URL, method: .get, parameters: ["id":user_id,  "group_id":device.group_id], encoding: URLEncoding.default, headers: nil).responseJSON
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
    
    @IBAction func onClickBack(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickEditGroup(_ sender: Any) {
        
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupNavController") as! UINavigationController
        let secondVC = navController.viewControllers.first as! EditGroupViewController
        secondVC.group = device
        secondVC.is_update = true
        self.present(navController, animated: true, completion: nil)

    }
    
    
    @IBAction func onClickSaveChanges(_ sender: Any) {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Update Group"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let dim_value = String.init(format: "%d", Int(vertical_progress.progress*100))
        let led_status:Int = switch_status.isOn ? 1 : 0
        let led_state:Int = device.group_led_state ? 1 : 0
        
        Alamofire.request(Constants.RequestURL.UPDATE_TOUCH_GROUP_URL, method: .get, parameters: ["id":user_id,  "group_id":device.group_id, "dim":dim_value, "led_state":led_status, "state":led_state], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
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
    @IBAction func onClickSettingdButton(_ sender: Any) {
//        bt_advanced.selected_value = !bt_advanced.selected_value
//        showHideAdvancedView()
        
        self.performSegue(withIdentifier: "toGroupSettingPage", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        bt_advanced.selected_value = false
//        showHideAdvancedView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProgressBar(_sender:)))
        vertical_progress.addGestureRecognizer(tap)
        vertical_progress.isUserInteractionEnabled = true
        vertical_progress.fillDoneColor = Constants.ControlColor.Dark_Green_Color
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bt_dim_down(_ sender: Any) {
        var progress_value = vertical_progress.progress - 0.1
        if progress_value < 0.1 {
            progress_value = 0.1
        }
        vertical_progress.setProgress(progress: progress_value, animated: true)
    }
    
    @IBAction func bt_dim_up(_ sender: Any) {
        var progress_value = vertical_progress.progress + 0.1
        if progress_value > 1{
            progress_value = 1
        }
        vertical_progress.setProgress(progress: progress_value, animated: true)
    }
    
    func showHideAdvancedView(){
        if(bt_advanced.selected_value == false){
            
            bt_save_changes.frame =   CGRect(x:view_advanced.frame.origin.x, y:view_advanced.frame.origin.y + 5, width:view_advanced.frame.size.width, height:35);
            bt_edit_group.frame =   CGRect( x:bt_save_changes.frame.origin.x, y:(bt_save_changes.frame.origin.y + bt_save_changes.frame.size.height + 5), width:bt_save_changes.frame.size.width, height:35);
            view_advanced.isHidden = true;
            bt_advanced.setTitle("Advanced>>", for: .normal)
        }
        else{
            bt_save_changes.frame =   CGRect(x:view_advanced.frame.origin.x, y:view_advanced.frame.origin.y+view_advanced.frame.size.height+5, width:view_advanced.frame.size.width, height:35);
            bt_edit_group.frame =   CGRect(x:bt_save_changes.frame.origin.x, y:bt_save_changes.frame.origin.y + 5 + bt_save_changes.frame.size.height, width:bt_save_changes.frame.size.width, height:35);
            view_advanced.isHidden = false;
            bt_advanced.setTitle("Advanced<<", for: .normal)
        }
    }
    
    
    func initAllUIBasedOnDevice(){
        vertical_progress.setProgress(progress: Float(device.group_dim_value)/100.0, animated: true)
        if(device.group_led_state){
            img_state.image = UIImage(named:"device_touch_status_on")
        }
        else{
            img_state.image = UIImage(named:"device_touch_status_off")
        }
//        switch_status.isOn = device.group_led_status
        txt_group_name.text = device.group_name
        
    }

    func handleProgressBar(_sender:UITapGestureRecognizer){
        let touchPoint = _sender.location(in: self.vertical_progress)
        var current_percentage = (1 - touchPoint.y / (self.vertical_progress.frame.height - 3))
        if(current_percentage < 0.1){
            current_percentage = 0.1
        }
        vertical_progress.setProgress(progress: Float(current_percentage), animated: true)
    }
    @available(iOS 10.0, *)
    @IBAction func onTapRecButton(_ sender: Any) {
        
        self.recButton.backgroundColor = UIColor(displayP3Red: 182/255, green: 200/255, blue: 40/255, alpha: 1.0)
        recView.isHidden = false
        loadingAcitivity = NVActivityIndicatorView(frame: CGRect(x: (recView.frame.width)/2 - 22.5, y: 20, width: 45, height: 45), type: .lineScalePulseOut, color: .white, padding: CGFloat(0))
        
        loadingAcitivity?.startAnimating()
        recView.addSubview(loadingAcitivity!)
        
    }
}
