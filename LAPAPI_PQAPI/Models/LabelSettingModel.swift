//
//  LabelSettingModel.swift
//  BaplsID
//
//  Created by nteam on 13/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import Foundation

class LabelSettingModel : Codable{
    
    //MARK:- OBJECTS
    
    var firstName         : Bool = true
    var familyName        : Bool = true // last name
    var fullName          : Bool = true
    var DOB               : Bool = true
    var dateOfIssue       : Bool = true
    var dateOfExpiry      : Bool = true
    var documentNumber    : Bool = true
    var fullAddress       : Bool = true
    var street            : Bool = true
    var city              : Bool = true
    var state             : Bool = true
    var postalCode        : Bool = true
    var sex               : Bool = true
    var vehicleClass      : Bool = true
    var endorsement       : Bool = true
    var driverRestriction : Bool = true
    var Age               : Bool = true
    var height            : Bool = true
    var weight            : Bool = true
    var time              : Bool = true
}
