//
//  WifiPasswordViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/8/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
class WifiPasswordViewController: UIViewController {
    var txt_ssid_content:String = String()
    @IBOutlet weak var checkbox: CheckboxButton!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_ssid: UITextField!
    var loadingView:UIViewController = UIViewController()
    var smartlib:HFSmartLink?
    var isconnecting:Bool = false
    var successBlock:SmartLinkSuccessBlock = {
        dev in
            return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = (storyboard?.instantiateViewController(withIdentifier: "loading_view"))!
//        txt_ssid.text = txt_ssid_content
        smartlib = HFSmartLink.shareInstence()
        smartlib?.isConfigOneDevice = true
        smartlib?.waitTimers = 30;
//        checkbox.isChecked = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onClickShowPasswordCheck(_ sender: CheckboxButton) {
        if(sender.isChecked){
            self.txt_password.isSecureTextEntry = false;
        }
        else{
            self.txt_password.isSecureTextEntry = true;
        }

    }
    
      @IBAction func onClickSetupTouch(_ sender: Any) {
        if (txt_ssid.text?.isEmpty)! {
            self.view.makeToast("Enter the Wifi name, please")
            return
        }
        if (txt_password.text?.isEmpty)!{
            self.view.makeToast("Enter the Password, please")
            return
        }
        
        self.performSegue(withIdentifier: "ToScanWiFiPage", sender: nil)
        /**/
        addLoadingView()
        
//        if(!isconnecting)
//        {
//            isconnecting = true;
//            smartlib?.start(withSSID: txt_ssid_content, key: txt_password.text, withV3x: true,
//                            processblock: {
//                                (pro:Int) in
//                                    print("progress value is \(pro)")
//                                },
//
//                            successBlock: {
//                                dev in
//                                    self.onSuccess(mac_id: (dev?.mac)!, ip: (dev?.ip)!)
//                                    return
//                            },
//
//                            fail: {
//                                failMessage in
//                                    self.onFailed()
//                                    return
//
//                            },
//
//                            end: {
//                                deviceDic in
//                                    self.onFailed()
//                                    return
//                            })
//
//
//        }
//        else{
//            smartlib?.stop({
//                stopMsg, isOk in
//                if isOk {
//                    self.isconnecting = false
//                    self.removeLoadingView()
//                }
//                else{
//                    self.onFailed()
//                }
//
//            })
//        }
 /**/
//        onSuccess(mac_id: "mymac1234", ip: "myip123")
    }
    
    
    func onSuccess(mac_id:String, ip:String){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "addtouch_view") as! AddTouchViewController
        secondViewController.mac_id = mac_id
        self.present(secondViewController, animated: true, completion: nil)
        
    }
    
    func onFailed(){
        self.removeLoadingView()
        let alert = UIAlertController(title: "Error", message: "Unable to connect to Touch device.Please remove the wall plate and press the WI_Fi reset button located below the TOUCH pad.Wait 5 seconds and repeat the setup.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addLoadingView(){
        loadingView.view.frame = self.view.bounds;
        loadingView.willMove(toParentViewController: self)
        self.view.addSubview(loadingView.view)
        self.addChildViewController(loadingView)
        loadingView.didMove(toParentViewController: self)
    }
    
    func removeLoadingView(){
        loadingView.willMove(toParentViewController: nil)
        loadingView.view.removeFromSuperview()
        loadingView.removeFromParentViewController()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "scandevice_controller") as! ScanDeviceViewController
        self.present(secondViewController, animated: true, completion: nil)
//        removeLoadingView()
    }
    
}
