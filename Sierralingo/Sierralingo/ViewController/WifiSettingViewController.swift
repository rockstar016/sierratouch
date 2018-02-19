//
//  WifiSettingViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/8/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit

class WifiSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onClickOpenWifiSettings(_ sender: Any) {
        let url_10 = URL(string: "prefs:root=WIFI")
        if(UIApplication.shared.canOpenURL(url_10!)){
                //pre ios  10
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url_10!, options: [:], completionHandler: {(success) in
                    print("kdjkdjrkjkdjkrjd")
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string:"App-Prefs:root=Settings&path=General")!)
                print("kdukrudkudkr")
            }
        }
        else{
            // ios 10
            UIApplication.shared.openURL(URL(string:"App-Prefs:root=Settings&path=General")!)
            print("kdurkdkudkurkud")
            WhenBack.sharedInstance.Key = true
        }
    }

}
