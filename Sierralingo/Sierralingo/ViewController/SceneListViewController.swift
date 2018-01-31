//
//  SceneListViewController.swift
//  Sierralingo
//
//  Created by Rock on 3/6/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast_Swift

class SceneListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table_scene: UITableView!
    var data_source = [SceneModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitPushedController()
        self.getSceneListService()
        self.table_scene.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSceneListService(){
        let prog = MBProgressHUD.showAdded(to: self.view, animated: true)
        prog.label.text = "Loading Scene"
        data_source.removeAll()
        let user_id = DataSaveReference.readStringData(key: DataSaveReference.USER_ID)
        Alamofire.request(Constants.RequestURL.GET_SCENE_URL, method: .get, parameters: ["id": user_id], encoding: URLEncoding.default, headers: nil).responseJSON
            {
                response  in
                prog.hide(animated: true)
                switch (response.result)
                {
                case .success(let JSON):
                    let res = JSON as! [NSDictionary]
                    for scene in res
                    {
                        let scene_model = SceneModel()
            
                        scene_model.id = Int(scene.object(forKey: "id") as! String)!
                        scene_model.devices = scene.object(forKey: "devices") as! String
                        scene_model.owner_id = scene.object(forKey: "owner_id") as! String
                        scene_model.dimvalue = scene.object(forKey: "dimvalue") as! String
                        
                        //check here point
                        scene_model.scene_turn = Int(scene.object(forKey: "scene_value") as! String)!
                        scene_model.turnvalue = scene.object(forKey: "turnvalue") as! String
                        scene_model.scene_name = scene.object(forKey: "scene_name") as! String
                        self.data_source.append(scene_model)
                    }
                    self.table_scene.reloadData()
                    break
                case .failure:
                    self.view.makeToast("Failed to load schedule. Try again")
                    break
                }
        }

    }
    
    
    
    
    @IBAction func onClickBackButton(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "touchListActivity") as! TouchListViewController
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickAddScene(_ sender: RoundGreenButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "scene_edit_controller") as! SceneEditViewController
        secondViewController.is_update = false
        secondViewController.scene_model = SceneModel()
        
        self.present(secondViewController, animated: true, completion: nil)

    }
    
        
    func clickEditButton(index:Int){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "scene_edit_controller") as! SceneEditViewController
        secondViewController.is_update = true
        secondViewController.scene_model = data_source[index]
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    
    
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data_source.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x:1, y:3, width:self.view.frame.size.width - 2, height:83))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scene_table_item", for: indexPath) as! SceneListViewCell
        cell.setDataSource(data_source[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickEditButton(index: indexPath.row)
    }
}
