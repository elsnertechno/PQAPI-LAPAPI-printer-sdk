//
//  ScannedDataModel.swift
//  BaplsID
//
//  Created by nteam on 12/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import Foundation

class scannedData{
    
    //MARK:- OBJECTS
    
    let firstName : String?
    let familyName : String? // last name
    let DOB : String?
    let age : String?
    let dateOfIssue : String?
    let dateOfExpiry : String?
    let documentNumber : String?
    let street : String?
    let city : String?
    let state : String?
    let postalCode : String?
    let sex : String?
    let vehicleClass : String?
    let endorsement : String?
    let driverRestriction : String?
    let currentDate : String?
    let height : String?
    let weight : String?
    
    //MARK:- INITILIZATION
    
    init(disc : [String : AnyHashable]) {
        self.firstName = disc[ScannedDataPrefix.firstName] as? String
        self.familyName = disc[ScannedDataPrefix.familyName] as? String
        self.DOB = disc[ScannedDataPrefix.DOB] as? String
        self.age = disc[ScannedDataPrefix.age] as? String
        self.dateOfIssue = disc[ScannedDataPrefix.dateOfIssue] as? String
        self.dateOfExpiry = disc[ScannedDataPrefix.dateOfExpiry] as? String
        self.documentNumber = disc[ScannedDataPrefix.documentNumber] as? String
        self.street = disc[ScannedDataPrefix.street] as? String
        self.city = disc[ScannedDataPrefix.city] as? String
        self.state = disc[ScannedDataPrefix.state] as? String
        self.postalCode = disc[ScannedDataPrefix.postalCode] as? String
        self.sex = disc[ScannedDataPrefix.sex] as? String
        self.vehicleClass = disc[ScannedDataPrefix.vehicleClass] as? String
        self.endorsement = disc[ScannedDataPrefix.endorsement] as? String
        self.driverRestriction = disc[ScannedDataPrefix.driverRestriction] as? String
        self.currentDate = disc[ScannedDataPrefix.currentDateTime] as? String
        self.height = disc[ScannedDataPrefix.height] as? String
        self.weight = disc[ScannedDataPrefix.weight] as? String
    }
}
