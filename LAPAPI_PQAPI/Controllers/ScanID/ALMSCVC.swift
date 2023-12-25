//
//  ALMSCVC.swift
//  BaplsID
//
//  Created by Elsner on 29/12/20.
//  Copyright © 2020 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class ALMSCVC: UIViewController {

    
    //MARK:- OUTLETS
    @IBOutlet weak var agencyTextField: UITextField!
    @IBOutlet weak var caseTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    var addedAgency: ( (_ agency: String, _ agencycase: String) -> (Void))!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        agencyTextField.layer.borderWidth = 1
        agencyTextField.layer.borderColor = UIColor.colorNavBg.cgColor
        caseTextField.layer.borderWidth = agencyTextField.layer.borderWidth
        caseTextField.layer.borderColor = UIColor.colorNavBg.cgColor
        agencyTextField.layer.cornerRadius = 5
        agencyTextField.layer.masksToBounds = true
        caseTextField.layer.cornerRadius = agencyTextField.layer.cornerRadius
        caseTextField.layer.masksToBounds = true
                
        cancelButton.backgroundColor = UIColor.colorNavBg
        okButton.backgroundColor = UIColor.colorNavBg
        
        agencyTextField.placeholder = prefixTitle.enterTechnicianName
        caseTextField.placeholder = prefixTitle.enterAgencyCase
        cancelButton.setTitle(ButtonTitle.CANCEL.uppercased(), for: .normal)
        okButton.setTitle(ButtonTitle.OK.uppercased(), for: .normal)
                
    }

    
    //MARK:- BUTTON'S ACTION
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        var error = ""
        if agencyTextField.text == "" {
            error = Messages.ENTER_TECHNICIAN
        }
//        else if caseTextField.text == "" {
//            error = Messages.ENTER_AGENCYCASE
//        }
        if error != "" {
            showAlert(message: error, arrActionTitles: [ButtonTitle.OK], buttonClicked: nil)
        } else {
            if addedAgency != nil {
                addedAgency(agencyTextField.text ?? "", caseTextField.text ?? "")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ALMSCVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == agencyTextField {
            return newString.length <= MAXAGENCY
        } else if textField == caseTextField {
            return newString.length <= MAXAGENCYCASE
        }
        return true
    }
}
