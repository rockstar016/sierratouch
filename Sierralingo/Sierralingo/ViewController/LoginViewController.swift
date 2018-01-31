//
//  LoginViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import MBProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var chk_show_password: CheckboxButton!
    @IBOutlet weak var check_auto_login: CheckboxButton!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let auto_login = DataSaveReference.readBoolData(key: DataSaveReference.USER_AUTO_LOGIN)
        let show_password = DataSaveReference.readBoolData(key: DataSaveReference.USER_PASSWORD_SHOW)
        check_auto_login.isChecked = auto_login
        chk_show_password.isChecked = show_password
        if(auto_login == true){
            let user_email  = DataSaveReference.readStringData(key: DataSaveReference.USER_EMAIL)
            let user_password = DataSaveReference.readStringData(key: DataSaveReference.USER_PASSWORD)
            if(!user_email.isEmpty && !user_password.isEmpty){
                ProcessLogin(EmailAddress:user_email, password: user_password);
            }
        }
        
    }
    
    func ProcessLogin(EmailAddress email:String, password:String){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Log in"
        
        Alamofire.request(Constants.RequestURL.LOGIN_URL, method: .get, parameters: ["email":email, "password":password], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                    case .success(let JSON):
                        let res = JSON as! NSDictionary
                        let success_value = res.object(forKey: "success") as! NSInteger
                        if(success_value == Constants.ResponseResult.SUCCESS_KEY){
                           
                            let res_user  = res.object(forKey: "user") as! NSDictionary
                            let res_email = res_user.object(forKey: "email") as! String
                            let res_id = res_user.object(forKey: "id") as! String
                           
                            DataSaveReference.saveStringData(value:res_email , key: DataSaveReference.USER_EMAIL)
                            DataSaveReference.saveStringData(value: res_id, key: DataSaveReference.USER_ID)
                            DataSaveReference.saveStringData(value: self.txt_password.text!, key: DataSaveReference.USER_PASSWORD)
                            self.goMainScreen()
                        }
                        else{
                            self.view.makeToast("Failed to log in. Try again")
                        }
                        break
                    case .failure:
                    break
                }
            }
    }
    
    func goMainScreen()
    {
                let tabViewController =  self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! TouchMainRootController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    @IBAction func OnClickLoginButton(_ sender: Any) {
        if(validationForm()){
            ProcessLogin(EmailAddress: txt_email.text!, password: txt_password.text!)
        }
        

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validationForm()->Bool{
        
        if(self.txt_email.text?.isEmpty)!{
            self.view.makeToast("Please, Enter the email.")
            return false;
        }
        
        if(self.txt_password.text?.isEmpty)!{
            self.view.makeToast("Please, Enter the password.")
            return false;
        }
        
        if(isValidEmail(testStr: self.txt_email.text!) == false){
            self.view.makeToast("Please, Enter the valid email.")
            return false;
        }
        return true
        
    }
    
    @IBAction func OnClickRegisterButton(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController

        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func chk_auto_login(_ sender: CheckboxButton){
        DataSaveReference.saveBoolData(value: sender.isChecked, key: DataSaveReference.USER_AUTO_LOGIN)
    }

    @IBAction func chk_show_password(_ sender: CheckboxButton) {
        DataSaveReference.saveBoolData(value: sender.isChecked, key: DataSaveReference.USER_PASSWORD_SHOW)
        if(sender.isChecked){
            self.txt_password.isSecureTextEntry = false;
        }
        else{
            self.txt_password.isSecureTextEntry = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
