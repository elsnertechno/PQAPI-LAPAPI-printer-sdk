//
//  SplashScreenVC.swift
//  BaplsID
//
//  Created by nteam on 17/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    //MARK:- GLOBAL VARIABLES
    
    var serverData : [[String:String]] = []
    var time = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fetchAPICall), userInfo: nil, repeats: false)
    }
    
    //MARK:- CUSTOM FUNCTION
    
    @objc func fetchAPICall() {
        
//        if isConnectedToInternet(withAlert: true){
//            showProgressIn(viewcotroller: self)
//            apiManager.callJsonRequest(strURL: GET_DATA_URL, httpMethod:.get, params: nil) {(response, error) in
//                DispatchQueue.main.async {
//                    hideProgress()
//                    if let code = response?[kSuccess] as? Int{
//                        if code == kResponceCode {
//                            self.serverData = response?[kResponceData] as! [[String:String]]
//                            if self.serverData.count > 0{
//                                self.time.invalidate()
//                                self.resetLocalStorage(serverData: self.serverData)
//                            }else{
//                                DispatchQueue.main.async {
//                                    self.time.invalidate()
//                                    Utility.shared.setSidePanelWithHome()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }else{
            DispatchQueue.main.async {
                self.time.invalidate()
                Utility.shared.setSidePanelWithHome()
            }
        }
    
    func resetLocalStorage(serverData : [[String:String]]) {
        let status = SqliteManager.shared.DMLExecuteQuery("delete from \(kTableName)")
        if status {
            SqliteManager.shared.bulkInsert(passScannedData: serverData)
            DispatchQueue.main.async {
                Utility.shared.setSidePanelWithHome()
            }
        }else{
            DispatchQueue.main.async {
                Utility.shared.setSidePanelWithHome()
            }
        }
    }
}
