//
//  RegisterViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/1/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import MBProgressHUD
extension UIViewController
{
    func InitPushedController() -> Void {
        navigationController?.navigationBar.barTintColor = Constants.ControlColor.Green_Color
        navigationController?.navigationBar.tintColor = Constants.AppColors.White_Color
    }
}

class RegisterViewController: UIViewController {
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_zipcode: UITextField!
    @IBOutlet weak var txt_lastname: UITextField!
    @IBOutlet weak var txt_first_name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        InitPushedController()
    }

    @IBAction func onClickRegister(_ sender: RoundGreenButton) {
        if(validationForm() == true){
            let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
            prog.label.text = "Register"
            
            Alamofire.request(Constants.RequestURL.REGISTER_URL, method: .get, parameters: ["first":txt_first_name.text!, "last":txt_lastname.text!, "zip":txt_zipcode.text!, "email":txt_email.text!, "password":txt_password.text!], encoding: URLEncoding.default, headers: nil).responseJSON
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
                                
                                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "touchListActivity") as! TouchListViewController
                                self.present(secondViewController, animated: true, completion: nil)
                            }
                            else{
                                self.view.makeToast("Failed to registering. Try again")
                            }
                            break
                        case .failure:
                            break
                    }
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if(self.txt_zipcode.text?.isEmpty)!{
            self.view.makeToast("Please, Enter the zipcode.")
        }
        
        if(self.txt_first_name.text?.isEmpty)!{
            self.view.makeToast("Please, Enter the first name.")
        }
        
        if(self.txt_lastname.text?.isEmpty)!{
            self.view.makeToast("Please, Enter the last name.")
        }
        
        if(isValidEmail(testStr: self.txt_email.text!) == false){
            self.view.makeToast("Please, Enter the valid email.")
            return false;
        }
        return true
        
    }
    
}
