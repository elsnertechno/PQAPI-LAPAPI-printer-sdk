//
//  SearchVC.swift
//  BaplsID
//
//  Created by nteam on 11/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- OBJECTS & OUTLETS
    
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var txtDateOfIssue: UITextField!
    @IBOutlet var txtDateOfExpiry: UITextField!
    @IBOutlet var btnSearch: UIButton!
    
    //MARK:- GLOBAL VARIABLES
    
    let datePicker = UIDatePicker()
    var selectedTextField : UITextField?
    
    //MARK:- VIEW CONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    //MARK:- CUSTOM FUNTIONS
    
    func setupUI() {
        self.txtDOB.delegate          = self
        self.txtDateOfIssue.delegate  = self
        self.txtDateOfExpiry.delegate = self
        self.btnSearch.makeCornerRedius(radius: self.btnSearch.frame.height / 2)
        self.btnSearch.clipsToBounds   = true
        self.btnSearch.backgroundColor = UIColor(hexString: Colors.themeColor)
    }
    
    func showDatePicker(textField : UITextField){
        
        self.datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton   = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donedatePicker))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView          = self.datePicker
    }
    
    //MARK:- DATE PICKER ACTIONS
    
    @objc func donedatePicker() {
        let formatter                = DateFormatter()
        formatter.dateFormat         = "MM/dd/yyyy"
        self.selectedTextField?.text = formatter.string(from: self.datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    //MARK:- TEXTFIELD DELEGATE METHODS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
        self.showDatePicker(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.selectedTextField = nil
    }
    
    //MARK:- BUTTON'S ACTIONS
    
    @IBAction func btnSearchPressed(_ sender: UIButton) {
        
        if self.txtFirstName.text == "" {
            showAlert(message: Messages.ENTER_FIRST_NAME, arrActionTitles: ["OK"], buttonClicked: nil)
        }
        else if self.txtLastName.text == "" {
            showAlert(message: Messages.ENTER_LAST_NAME, arrActionTitles: ["OK"], buttonClicked: nil)
        }
        else if self.txtDOB.text == "" {
            showAlert(message: Messages.SELECT_DOB, arrActionTitles: ["OK"], buttonClicked: nil)
        }
        else if self.txtDateOfIssue.text == "" {
            showAlert(message: Messages.SELECT_DATE_OF_ISSUE, arrActionTitles: ["OK"], buttonClicked: nil)
        }
        else if self.txtDateOfExpiry.text == "" {
            showAlert(message: Messages.SELECT_DATE_OF_EXPIRY, arrActionTitles: ["OK"], buttonClicked: nil)
        }
        else {
            let queryString = "select * from \(kTableName) where \(ScannedDataPrefix.firstName) = '\(self.txtFirstName.text!.uppercased())' AND \(ScannedDataPrefix.familyName) = '\(self.txtLastName.text!.uppercased())' AND \(ScannedDataPrefix.DOB) = '\(self.txtDOB.text!)' AND \(ScannedDataPrefix.dateOfIssue) = '\(self.txtDateOfIssue.text!)' AND \(ScannedDataPrefix.dateOfExpiry) = '\(self.txtDateOfExpiry.text!)';"
            
            let result = SqliteManager.shared.SelectQuery(queryString)
            
            if result.count > 0 {
                let data = result[0]
                
                let vc:CustomerInfoVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
                vc.filteredData = data
                vc.isFromSearch = true
                
                DispatchQueue.main.async {
                    self.pushTo(viewController: vc, animate: true)
                }
            }else{
                showAlert(message: Messages.DATA_NOT_FOUND, buttonClicked: nil)
            }
        }
    }
}
