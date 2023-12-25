//
//  PrinterSettingVC.swift
//  BaplsID
//
//  Created by Ahmad's MacMini on 25/01/23.
//  Copyright © 2023 Hardik's Mac Mini. All rights reserved.
//


var KEY_SELECTED_PRINTER = "SELECTED_PRINTER"

enum SectionName : String {
    case HomeDraw = "HomeDraw"
    case SFPD = "SFPD"
    case ALMSC = "ALM/SC/SM"
    case C19 = "C19"
    case MC = "MC"
}

public enum KeyForSectionName : String{
    case KEY_HOMEDRAW = "KEY_HOMEDRAW"
    case KEY_SFPD = "KEY_SFPD"
    case KEY_ALMSC = "KEY_ALMSC"
    case KEY_C19 = "KEY_C19"
    case KEY_MC = "KEY_MC"
}

import UIKit

struct Section{
    var sectionName : SectionName
    var count : Int
}

class PrinterSettingVC: UIViewController {

    @IBOutlet var lblSelectPrinter: UILabel!
    @IBOutlet var viewPickerSelection: UIView!
    @IBOutlet var txtPrinterSelection: UITextField!
    @IBOutlet var lblSelectNoOfPrint: UILabel!
    @IBOutlet var viewListOfSection: UIView!
    @IBOutlet var tblViewListOfSection: UITableView!
    
    var arrSectionList : [Section] = []
    
    var pickerPrinterSelection = UIPickerView()
    var arrPrinter : [Printers] = [Printers.bluePrinter, Printers.brownPrinter]
    var selectedPrinter : Printers = .bluePrinter
    
    var arrKeyForSectionName : [KeyForSectionName] = [.KEY_HOMEDRAW,
                                                      .KEY_SFPD,
                                                      .KEY_ALMSC,
                                                      .KEY_C19,
                                                      .KEY_MC]
    override func viewDidLoad() {
        super.viewDidLoad()

        arrSectionList = [Section(sectionName: .HomeDraw, count: getDefaultCountOfSection(key: .KEY_HOMEDRAW)),
                          Section(sectionName: .SFPD, count: getDefaultCountOfSection(key: .KEY_SFPD)),
                          Section(sectionName: .ALMSC, count: getDefaultCountOfSection(key: .KEY_ALMSC)),
                          Section(sectionName: .C19, count: getDefaultCountOfSection(key: .KEY_C19)),
                          Section(sectionName: .MC, count: getDefaultCountOfSection(key: .KEY_MC))]
                
        tblViewListOfSection.delegate = self
        tblViewListOfSection.dataSource = self
        
        // Do any additional setup after loading the view.
        
        // Add inputView in selection of printer
        if #available(iOS 13.0, *) {
            
            txtPrinterSelection.inputView = pickerPrinterSelection
            pickerPrinterSelection.delegate = self
            
            
            let strSelected = UserDefaults.standard.value(forKey: KEY_SELECTED_PRINTER) as? String ?? Printers.bluePrinter.rawValue
            
            selectedPrinter = (strSelected == Printers.brownPrinter.rawValue) ? .brownPrinter : .bluePrinter
            
            txtPrinterSelection.text = selectedPrinter.rawValue
            
            switch selectedPrinter {
            case .bluePrinter:
                pickerPrinterSelection.selectRow(0, inComponent: 0, animated: true)
                break
            case .brownPrinter:
                pickerPrinterSelection.selectRow(1, inComponent: 0, animated: true)
                break
            default:
                break
            }
            
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = UIImage(systemName: "chevron.down")
            imageView.tintColor = .lightGray
            imageView.contentMode = .scaleAspectFit
            rightView.addSubview(imageView)
            
            txtPrinterSelection.rightView = rightView
            txtPrinterSelection.rightViewMode = .always
            
        } else {
            // Fallback on earlier versions
        }

        
    }
    
    
    @objc func stepperValueChanged(sender:UIStepper){
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = tblViewListOfSection.cellForRow(at: indexPath) as? SectionListCell else {
            return
        }
        
        let count = Int(sender.value)
        cell.lblCount.text = "\(count)"
        
        switch sender.tag {
        case 0:
            setDefaultCountOfSection(key: .KEY_HOMEDRAW, count: count)
            break
        case 1:
            setDefaultCountOfSection(key: .KEY_SFPD, count: count)
            break
        case 2:
            setDefaultCountOfSection(key: .KEY_ALMSC, count: count)
            break
        case 3:
            setDefaultCountOfSection(key: .KEY_C19, count: count)
            break
        case 4:
            setDefaultCountOfSection(key: .KEY_MC, count: count)
            break
        default:
            break
        }
        
//        tblViewListOfSection.reloadData()
        
//        sender.value
//        if sender.stepValue != 0{
//                 countArray[sender.tag] = Int(sender.value)
//             }
//        tblViewListOfSection.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PrinterSettingVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPrinter.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPrinter[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPrinter = arrPrinter[row]
        UserDefaults.standard.set(selectedPrinter.rawValue, forKey: KEY_SELECTED_PRINTER)
        txtPrinterSelection.text = selectedPrinter.rawValue
    }
}


extension PrinterSettingVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionListCell", for: indexPath) as? SectionListCell else{
            return UITableViewCell()
        }
        
        cell.lblSectionName.text = arrSectionList[indexPath.row].sectionName.rawValue
        cell.lblStepper.minimumValue = 1.0
        cell.lblStepper.maximumValue = 99.0
        cell.lblStepper.value = Double(arrSectionList[indexPath.row].count)
        cell.lblStepper.tag = indexPath.row
        cell.lblCount.text = "\(arrSectionList[indexPath.row].count)"
        cell.lblStepper.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
