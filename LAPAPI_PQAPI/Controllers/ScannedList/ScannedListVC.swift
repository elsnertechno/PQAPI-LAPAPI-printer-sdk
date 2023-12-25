//
//  ScannedListVC.swift
//  BaplsID
//
//  Created by nteam on 11/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class ScannedListVC: UIViewController {
    
    //MARK:- IBOUTLET
    
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- GLOBAL VARIABLE
    
    var scannedList : [[String:String]] = []
    var searchEnabled : Bool = false
    var searchresult:[Any] = []
    
    //MARK:- VIEW CONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        scannedList = SqliteManager.shared.SelectQuery("select * from \(kTableName)")
        if scannedList.count > 0 {
            tableView.reloadData()
        }
    }
    
    //MARK:- CUSTOM FUNCTION
    
    func displayScannedData(dict : [String:String]) -> String {
        print(dict)
        var strFinal : String = ""
        var fullName : String = ""
        if dict.keys.contains(ScannedDataPrefix.firstName) {
            fullName.append("\(dict[ScannedDataPrefix.firstName]!) ")
        }
        if dict.keys.contains(ScannedDataPrefix.familyName) {
            fullName.append("\(dict[ScannedDataPrefix.familyName]!)")
            strFinal.append("\(prefixTitle.fullName): \(fullName) \n")
        }
        if dict.keys.contains(ScannedDataPrefix.documentNumber) {
            strFinal.append("\(prefixTitle.documentNumber) : \(dict[ScannedDataPrefix.documentNumber]!) \n")
        }
        if dict.keys.contains(ScannedDataPrefix.dateOfIssue) {
            strFinal.append("\(prefixTitle.dateOfIssue): \(dict[ScannedDataPrefix.dateOfIssue]!) \n")
        }
        if dict.keys.contains(ScannedDataPrefix.dateOfExpiry) {
            strFinal.append("\(prefixTitle.dateOfExpiry): \(dict[ScannedDataPrefix.dateOfExpiry]!) \n")
        }
        if dict.keys.contains(ScannedDataPrefix.currentDateTime) {
            strFinal.append("\(prefixTitle.currentDateTime): \(dict[ScannedDataPrefix.currentDateTime]!)")
        }
        return strFinal
    }
}

//MARK:- EXTENSION TABLEVIEW

extension ScannedListVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchEnabled == true{
            return  searchresult.count
        }
        else{
            return scannedList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannedListTableViewCell", for: indexPath) as! ScannedListTableViewCell
        var dict:[String: String] = [:]
        if searchEnabled == true {
            dict =  searchresult[indexPath.row] as! [String: String]
        }
        else{
            dict  = scannedList[indexPath.row]
        }
        let str = displayScannedData(dict: dict)
        cell.backView.makeCornerRedius(radius: 10)
        cell.scannedDetailLbl.text = str
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict:[String: String] = [:]
        if searchEnabled == true {
            dict =  searchresult[indexPath.row] as! [String: String]
        }
        else{
            dict  = scannedList[indexPath.row]
        }
        let vc:CustomerInfoVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
        vc.filteredData = dict
        vc.isFromSearch = true
        DispatchQueue.main.async {
            self.pushTo(viewController: vc, animate: true)
        }
    }
}

//MARK:- EXTENSION SEARCHBAR

extension ScannedListVC : UISearchBarDelegate{
    
    func filtertext(searchtext : String) {
        searchresult = scannedList.filter({ (dict) -> Bool in
            return dict[ScannedDataPrefix.firstName]!.lowercased().contains(searchtext.lowercased()) || dict[ScannedDataPrefix.familyName]!.lowercased().contains(searchtext.lowercased())
        })
        tableView.reloadData()
    }
    
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchEnabled = false
            tableView.reloadData()
        }
        else{
            searchEnabled = true
            self.filtertext(searchtext: searchText)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchEnabled = true
        searchBar.showsCancelButton = false
        self.filtertext(searchtext: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchEnabled = false
        searchBar.text = ""
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
        self.filtertext(searchtext: searchBar.text!)
    }
}
