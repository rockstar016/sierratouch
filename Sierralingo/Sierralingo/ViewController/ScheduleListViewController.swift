//
//  ScheduleListViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/4/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class ScheduleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table_schedule: UITableView!
    @IBOutlet weak var bt_day: RoundWhiteButton!
    @IBOutlet weak var txt_touch_location: UILabel!
    var touch_device:TouchDevice = TouchDevice()
    var schedule_list:Array = [ScheduleModel]()
    var disp_list:Array = [ScheduleModel]()
    
    var selected_index:Int = 0
    var day_list:[String] = ["All","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_touch_location.text = touch_device.device_location
        getScheduleListService()
    }

    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm:a"
        
        return dateFormatter.string(from: dt!)
    }
    
    
    func getScheduleListService(){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Loading Schedule"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let device_id = touch_device.device_id
        schedule_list.removeAll()
        Alamofire.request(Constants.RequestURL.GET_SCHEDULE_URL, method: .get, parameters: ["id": user_id, "device_id": device_id], encoding: URLEncoding.default, headers: nil).responseJSON
            {
                response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                    case .success(let JSON):
                        let res = JSON as! [NSDictionary]
                        for device in res
                        {
                            let sch_model = ScheduleModel()
                            sch_model.id = Int(device.object(forKey: "id") as! String)!
                            sch_model.deviceid = Int(device.object(forKey: "deviceid") as! String)!
                            sch_model.dimmer_value = Int(device.object(forKey: "dimmer_value") as! String)!
                            let dateTimeString = device.object(forKey: "utimestamp") as! String
                            sch_model.time_stamp = self.UTCToLocal(date: dateTimeString)
                            sch_model.ledonoff = (Int(device.object(forKey: "state") as! String)!) == 1
                            sch_model.workday = device.object(forKey: "workday") as! String
                            self.schedule_list.append(sch_model)
                        }
                        self.updateCollectionView()
                        break
                case .failure:
                        self.view.makeToast("Failed to load schedule. Try again")
                    break
                }
            }
    }
    
    func showAlert(sender: AnyObject) {
        let alert = UIAlertController(title: "Choose day", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: day_list[0], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 0
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[1], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 1
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[2], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 2
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[3], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 3
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[4], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 4
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[5], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 5
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[6], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 6
            self.updateCollectionView()
        }))
        alert.addAction(UIAlertAction(title: day_list[7], style: .default , handler:{ (UIAlertAction)in
            self.selected_index = 7
            self.updateCollectionView()
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func updateCollectionView(){
        self.bt_day.setTitle(day_list[selected_index], for: .normal)
        initDispList()
        table_schedule.reloadData()
    }
    
    func initDispList()  {
        disp_list.removeAll()
        if(selected_index == 0){
            self.disp_list = self.schedule_list
        }
        else{
            for temp_sch in schedule_list{
                if temp_sch.workday.contains(String(format: "%d",selected_index - 1)){
                    disp_list.append(temp_sch)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickDayButton(_ sender: Any) {
        self.showAlert(sender: sender as AnyObject)
    }
    
    @IBAction func onClickAddButton(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "sheduleaddupdate") as! SchduleAddUpdateViewController
        let temp_model = ScheduleModel()
        temp_model.deviceid = 0
        temp_model.dimmer_value = 100
        temp_model.id = 0
        temp_model.ledonoff = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:00:a"
        let time_val = formatter.string(from: Date())
        temp_model.time_stamp = time_val
        temp_model.workday = String()
        
        secondViewController.schedule_model = temp_model
        secondViewController.is_update = false
        secondViewController.touch_device = touch_device
        self.present(secondViewController, animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return disp_list.count
        
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shedulelistcell", for: indexPath) as! SchduleTableCell
        cell.setDataSource(disp_list[indexPath.row])
        cell.bt_remove.tag = indexPath.row
        cell.bt_remove.addTarget(self, action: #selector(onClickDelete(_:)), for: .touchUpInside)
        cell.bt_edit.addTarget(self, action: #selector(onClickEdit(_:)), for: .touchUpInside)
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x:0, y:2, width:self.view.frame.size.width, height:73))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "devicemanipulate") as! DeviceManipulateViewController
        secondViewController.device = touch_device
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func onClickDelete(_ sender: UIButton){
        let alert = UIAlertController(title: "Confirm", message: "Really want to remove this schedule?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
                self.removeSchduleService(index: sender.tag)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeSchduleService(index:Int){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Deleting Schedule"
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        let device_id = disp_list[index].id
        schedule_list.removeAll()
        Alamofire.request(Constants.RequestURL.REMOVE_SCHEDULE_URL, method: .get, parameters: ["user_id": user_id, "id": device_id], encoding: URLEncoding.default, headers: nil).responseJSON
            {
                response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! NSDictionary
                    let success_value = res.object(forKey: "success") as! NSInteger
                    if success_value == Constants.ResponseResult.SUCCESS_KEY{
                        self.getScheduleListService()
                    }
                    break
                case .failure:
                    self.view.makeToast("Failed to delete schedule. Try again")
                    break
                }
        }
    }
    
    
    func onClickEdit(_ sender:UIButton){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "sheduleaddupdate") as! SchduleAddUpdateViewController
        secondViewController.is_update = true
        secondViewController.schedule_model = disp_list[sender.tag]
        secondViewController.touch_device = touch_device
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    
}
