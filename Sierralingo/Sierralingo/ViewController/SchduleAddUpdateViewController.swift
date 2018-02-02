//
//  SchduleAddUpdateViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/6/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MLVerticalProgressView
import MBProgressHUD
import Alamofire
@available(iOS 10.0, *)

class SchduleAddUpdateViewController: UIViewController {

    @IBOutlet weak var switch_status: UISwitch!
    @IBOutlet var day_button_array: [DayButton]!
    @IBOutlet weak var time_picker: UIDatePicker!
    @IBOutlet weak var vertical_progress: VerticalProgressView!
    @IBOutlet weak var navigation_item: UINavigationItem!
    
    var schedule_model = ScheduleModel()
    var is_update = false
    var touch_device = TouchDevice()
    override func viewDidLoad() {
        super.viewDidLoad()
        if is_update == true {
//            self.navigation_item.title = "Edit Schedule"
        }
        else{
//            self.navigation_item.title = "Add to Schedule"
        }
        
        self.initAllUIBasedOnDevice()
    }
    
    func initAllUIBasedOnDevice(){
        vertical_progress.setProgress(progress: Float(schedule_model.dimmer_value)/100.0, animated: true)
        switch_status.isOn = schedule_model.ledonoff
        for i in 0...6{
            day_button_array[i].isChecked = schedule_model.workday.contains(String.init(format: "%d", i))
        }
        
    
        var strArr = schedule_model.time_stamp.characters.split{$0 == ":"}.map(String.init)
        
        var hour = Int(strArr[0])!
        let min = Int(strArr[1])!
        if(strArr[2] == "pm"){
            hour = hour + 12
        }
        
        let date = setTime(hour: hour, min: min)
        time_picker.timeZone = TimeZone.current
        time_picker.setDate(date!, animated: true)
    }
    
    public func setTime(hour: Int, min: Int) -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: Date())
        components.timeZone = TimeZone.current
        components.hour = hour
        components.minute = min
        
        return cal.date(from: components)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProgressBar(_sender:)))
        vertical_progress.addGestureRecognizer(tap)
        vertical_progress.isUserInteractionEnabled = true
        vertical_progress.fillDoneColor = Constants.ControlColor.Dark_Green_Color
    }

    func handleProgressBar(_sender:UITapGestureRecognizer){
        let touchPoint = _sender.location(in: self.vertical_progress)
        let current_percentage = (1 - touchPoint.y / (self.vertical_progress.frame.height - 3))
        vertical_progress.setProgress(progress: Float(current_percentage), animated: true)
    }

    
    @IBAction func onDimUpClick(_ sender: Any) {
        var progress_value = vertical_progress.progress + 0.1
        if progress_value > 1{
            progress_value = 1
        }
        vertical_progress.setProgress(progress: progress_value, animated: true)
    }
    @IBAction func onDimDownClick(_ sender: Any)
    {
        var progress_value = vertical_progress.progress - 0.1
        if progress_value < 0 {
            progress_value = 0
        }
        vertical_progress.setProgress(progress: progress_value, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onBackClick(_ sender: Any)
    {
            goParentScreen()
    }

    func goParentScreen(){
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "schedulelistview") as! ScheduleListViewController
//        secondViewController.touch_device = touch_device
//        self.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickSaveButton(_ sender: Any)
    {
        if is_update == true{
            self.updateSchedule()
        }
        else{
            self.addSchedule()
        }
    }
    
    func localToUTC(date:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    
    func makeTimeStamp() -> String
    {
        let current_date = time_picker.date
        
        let date_formatter = DateFormatter()
        
        date_formatter.timeZone = TimeZone(abbreviation: "UTC")
        date_formatter.dateFormat = "hh:mm:a"
        return date_formatter.string(from: current_date)
    }
    
    func makeWorkday()->String
    {
        var result:String = String()
        for i in 0...6
        {
            if(day_button_array[i].isChecked){
                result = result + String.init(format: "%d|", i)
            }
        }
        if(result.characters.count > 1){
            let index = result.index(result.startIndex, offsetBy: result.characters.count-1)
            result = result.substring(to: index)
        }
        return result
    }
    
    func updateSchedule()
    {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Update Schedule"
        let sch_id:Int = schedule_model.id;
        let dim_value:String = String.init(format: "%d", Int(vertical_progress.progress*100))
        let ledonoff:Int = switch_status.isOn == true ? 1 : 0
        let utimestamp:String = makeTimeStamp()
        let workday:String = makeWorkday()
        let user_id:String = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        Alamofire.request(Constants.RequestURL.UPDATE_SCHEDULE_URL, method: .get, parameters: ["id":sch_id,  "dim":dim_value, "workday":workday, "state":ledonoff, "utimestamp":utimestamp, "owner_id":user_id], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    let result = res.object(forKey: "success") as! Int
                    if result == Constants.ResponseResult.SUCCESS_KEY
                    {
                        self.goParentScreen()
                    }
                    else
                    {
                        self.view.makeToast("Failed to update. Try again")
                    }
                    
                    break
                case .failure:
                    self.view.makeToast("Failed to update. Try again")
                    break
                }
        }
    }
    
    func addSchedule()
    {
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Add Schedule"
        let dim_value:String = String.init(format: "%d", Int(vertical_progress.progress*100))
        let ledonoff:Int = switch_status.isOn == true ? 1 : 0
        let utimestamp:String = makeTimeStamp()
        let workday:String = makeWorkday()
        let user_id:String = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        Alamofire.request(Constants.RequestURL.ADD_SCHEDULE_URL, method: .get, parameters: ["deviceid":touch_device.device_id,  "dim":dim_value, "workday":workday, "state":ledonoff, "utimestamp":utimestamp, "owner_id":user_id], encoding: URLEncoding.default, headers: nil).responseJSON
            { response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    let result = res.object(forKey: "success") as! Int
                    if result == Constants.ResponseResult.SUCCESS_KEY{
                        
                        self.goParentScreen()
                    }
                    else{
                        self.view.makeToast("Failed to create. Try again")
                    }
                    
                    break
                case .failure:
                    self.view.makeToast("Failed to create. Try again")
                    break
                }
            }
    }
}
