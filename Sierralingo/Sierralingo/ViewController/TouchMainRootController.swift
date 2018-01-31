//
//  TouchMainRootController.swift
//  Sierralingo
//
//  Created by Rock on 1/15/18.
//  Copyright © 2018 Rock. All rights reserved.
//

import UIKit

class TouchMainRootController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName: UIFont(name: "Centime", size: 16),
                          NSForegroundColorAttributeName: UIColor.gray]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        let attributes1 = [NSFontAttributeName: UIFont(name: "Centime", size: 16),
                          NSForegroundColorAttributeName: UIColor.white]
        appearance.setTitleTextAttributes(attributes1, for: .selected)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
