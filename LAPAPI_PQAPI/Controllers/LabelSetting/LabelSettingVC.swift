//
//  LabelSettingVC.swift
//  BaplsID
//
//  Created by nteam on 11/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class LabelSettingVC: UIViewController {
    
    //MARK:- OBJECTS & OUTLETS
    
    @IBOutlet var topView: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblViewLabelSetting: UITableView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet weak var initialsDisplayLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    //MARK:- GLOBAL VARIABLE
    
    var labelSettingModel = LabelSettingModel()
    
    //MARK:- VIEW CONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //let def = UserDefaults()
        if let defValue = defaults.value(forKey: kJoin) as? String{
            initialsDisplayLabel.text = "\(prefixTitle.drawnBy): \(defValue)"
        }else{
            editButton.setTitle("Add", for: .normal)
        }
        self.labelSettingModel = Utility.shared.getLabelSettingData() ?? LabelSettingModel()
        self.tblViewLabelSetting.reloadData()
    }
    
    //MARK:- BUTTON'S ACTIONS
    
    @IBAction func btnSavePressed(_ sender: UIButton) {
        Utility.shared.setLabelSettingData(labelSetting: self.labelSettingModel)
        let scanVc : ScanIDVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
        Utility.shared.setCenterPanel(centerViewController: scanVc, fromVc: self)
    }
    @IBAction func editButtonTapped(_ sender: Any) {
        //let def = UserDefaults()
        let alert = UIAlertController(title: kAppName, message: "Enter your initials", preferredStyle: .alert)
        alert.addTextField { (FNameTextField) in
            FNameTextField.placeholder = "Enter Firstname"
            FNameTextField.autocapitalizationType = .sentences
        }
        alert.addTextField { (LNameTextField) in
            LNameTextField.placeholder = "Enter Lastname"
            LNameTextField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            let fname = alert.textFields?[0].text
            let lname = alert.textFields?[1].text
            
            if fname != "" && lname != ""{
                let fName = String(fname!.first!) + "."
                let lName = String(lname!)
                let makeJoin = fName + lName
                
                self.initialsDisplayLabel.text = "\(prefixTitle.drawnBy): \(makeJoin.uppercased())"
                defaults.setValue(makeJoin.uppercased(), forKey: kJoin)
                self.editButton.setTitle("Edit", for: .normal)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- CUSTOM FUNCTIONS
    
    func setupInitial() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.topView.backgroundColor = UIColor(hexString: Colors.themeColor)
        self.btnSave.makeCornerRedius(radius: self.btnSave.frame.height / 2)
        self.btnSave.backgroundColor = UIColor(hexString: Colors.themeColor)
        self.btnSave.clipsToBounds   = true
        self.tblViewLabelSetting.delegate   = self
        self.tblViewLabelSetting.dataSource = self
    }
    
    @objc func btnSelectionPressed(_ sender : UIButton) {
        
        if sender.tag == 0 {
            self.labelSettingModel.firstName = self.labelSettingModel.firstName ? false : true
        }
        else if sender.tag == 1 {
            self.labelSettingModel.familyName = self.labelSettingModel.familyName ? false : true
        }
        else if sender.tag == 2 {
            self.labelSettingModel.fullName = self.labelSettingModel.fullName ? false : true
        }
        else if sender.tag == 3 {
            self.labelSettingModel.DOB = self.labelSettingModel.DOB ? false : true
        }
        else if sender.tag == 4 {
            self.labelSettingModel.dateOfIssue = self.labelSettingModel.dateOfIssue ? false : true
        }
        else if sender.tag == 5 {
            self.labelSettingModel.dateOfExpiry = self.labelSettingModel.dateOfExpiry ? false : true
        }
        else if sender.tag == 6 {
            self.labelSettingModel.fullAddress = self.labelSettingModel.fullAddress ? false : true
        }
        else if sender.tag == 7 {
            self.labelSettingModel.vehicleClass = self.labelSettingModel.vehicleClass ? false : true
        }
        else if sender.tag == 8 {
            self.labelSettingModel.endorsement = self.labelSettingModel.endorsement ? false : true
        }
        else if sender.tag == 9 {
            self.labelSettingModel.driverRestriction = self.labelSettingModel.driverRestriction ? false : true
        }
        else if sender.tag == 10 {
            self.labelSettingModel.Age = self.labelSettingModel.Age ? false : true
        }
        else if sender.tag == 11 {
            self.labelSettingModel.sex = self.labelSettingModel.sex ? false : true
        }
        else if sender.tag == 12 {
            self.labelSettingModel.time = self.labelSettingModel.time ? false : true
        }
//        else if sender.tag == 12 {
//            self.labelSettingModel.height = self.labelSettingModel.height ? false : true
//        }
//        else if sender.tag == 13 {
//            self.labelSettingModel.weight = self.labelSettingModel.weight ? false : true
//        }
        self.tblViewLabelSetting.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
}

//MARK:- EXTENSION TABLEVIEW

extension LabelSettingVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelSettingTBLViewCell") as! LabelSettingTBLViewCell
        if indexPath.row == 0 {
            cell.lblFieldTitle.text = prefixTitle.firstName
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.firstName ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 1 {
            cell.lblFieldTitle.text = prefixTitle.familyName
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.familyName ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 2 {
            cell.lblFieldTitle.text = prefixTitle.fullName
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.fullName ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 3 {
            cell.lblFieldTitle.text = prefixTitle.DOB
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.DOB ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 4 {
            cell.lblFieldTitle.text = prefixTitle.dateOfIssue
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.dateOfIssue ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 5 {
            cell.lblFieldTitle.text = prefixTitle.dateOfExpiry
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.dateOfExpiry ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 6 {
            cell.lblFieldTitle.text = prefixTitle.fullAddress
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.fullAddress ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 7 {
            cell.lblFieldTitle.text = prefixTitle.vehicleClass
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.vehicleClass ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 8 {
            cell.lblFieldTitle.text = prefixTitle.endorsement
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.endorsement ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 9 {
            cell.lblFieldTitle.text = prefixTitle.driverRestriction
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.driverRestriction ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 10 {
            cell.lblFieldTitle.text = prefixTitle.age
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.Age ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 11 {
            cell.lblFieldTitle.text = prefixTitle.sex
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.sex ?  "check-box" : "icon"), for: .normal)
        }
        else if indexPath.row == 12 {
            cell.lblFieldTitle.text = prefixTitle.currentTime
            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.time ?  "check-box" : "icon"), for: .normal)
        }
//        else if indexPath.row == 12 {
//            cell.lblFieldTitle.text = prefixTitle.height
//            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.height ?  "check-box" : "icon"), for: .normal)
//        }
//        else if indexPath.row == 13 {
//            cell.lblFieldTitle.text = prefixTitle.weight
//            cell.btnSelection.setBackgroundImage(UIImage(named: self.labelSettingModel.weight ?  "check-box" : "icon"), for: .normal)
//        }
        cell.btnSelection.tag = indexPath.row
        cell.btnSelection.addTarget(self, action: #selector(self.btnSelectionPressed(_:)), for: .touchUpInside)
        return cell
    }
}
