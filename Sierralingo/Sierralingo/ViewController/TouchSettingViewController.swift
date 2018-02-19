//
//  TouchSettingViewController.swift
//  Sierralingo
//
//  Created by Sobura on 1/2/2018.
//  Copyright © 2018 Rock. All rights reserved.
//

import Foundation
import UIKit

class TouchSettingViewController: UIViewController {
    

    @IBOutlet weak var timezoneTextField: CustomTextField!
    @IBOutlet weak var propertyTextField: CustomTextField!
    @IBOutlet weak var deviceTextField: CustomTextField!
    
    let timeZoneTxt = ["Eastern Time(US/Canada)","Central Time(US/Canada)","Mountain Time(US/Canada)","Pacific Time(US/Canada)"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTapCheck1(_ sender: PencilButton)
    {
        if sender.isChecked
        {
            deviceTextField.isUserInteractionEnabled = true
        }
        else
        {
            deviceTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func onTapCheck2(_ sender: PencilButton)
    {
        if sender.isChecked
        {
            propertyTextField.isUserInteractionEnabled = true
        }
        else
        {
            propertyTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func onTapTimeZone(_ sender: Any) {
        
        let alertController = UIAlertController(title: "TimeZone", message: nil, preferredStyle: .actionSheet)
        timeZoneTxt.forEach { year in
            alertController.addAction(UIAlertAction(title: year, style: .default) { action in
                if let title = action.title {
                    
                    self.timezoneTextField.text = title
                }
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
