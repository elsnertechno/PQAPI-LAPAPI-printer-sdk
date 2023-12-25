//
//  BluetoothListVC.swift
//  BaplsID
//
//  Created by Ahmad's MacMini on 08/11/22.
//  Copyright © 2022 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class BluetoothListVC: UIViewController {

    @IBOutlet var tblViewBlList: UITableView!
    @IBOutlet var BTConnectLabel: UILabel!
    var printClosure : ((_ boolSuccess:Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        PQAPI.enableProgress(true)
        PQAPI.discoveredPeripheralBlock {
            self.tblViewBlList.reloadData()
        }
        PQAPI.didReadPrinterStateHandler { code, message in
            print("\(code) --- \(message)")
            if code == 0x30{
                self.BTConnectLabel.text = "Not connected";
                appDelegate.isPrinterAvailable = false
            }
        }
        
    }
    
    @IBAction func btnBLRefresh_Action(_ sender: UIButton) {
        PQAPI.refreshDiscoveredPeripheral()
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
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

//MARK: - UItableview Delegate and Datasource Methods
extension BluetoothListVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PQAPI.getDiscoveredPeripherals().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        cell.textLabel?.text = PQAPI.getDiscoveredPeripherals()[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral : CBPeripheral = PQAPI.getDiscoveredPeripherals()[indexPath.row]
        
        PQAPI.openPrinter(with: peripheral) { isSuccess in
            if isSuccess{
                self.BTConnectLabel.text = PQAPI.getConnectingPrinterName() ?? ""
                print("Connection successful \(PQAPI.getConnectingPrinterName() ?? "")")
                appDelegate.isPrinterAvailable = true
                self.printClosure?(true)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.dismiss(animated: true)
                })
                
            }else{
                appDelegate.isPrinterAvailable = false
                print("Connection failed")
            }
        }
    }
        
    
}
