
import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults = UserDefaults.standard

//MARK:- GLOBAL KEY SETTINGS

let kAppName = "BaplsID"
let kUserData = "UserData"
let kSuccess = "code"
let kMessage = "message"
let kSomethingWentWrong = "Something Went Wrong, Try Again."
let kResponceCode = 200
let kResponceData = "data"

let kLabelSetting = "LabelSetting"
let kTableName = "ScannedDataStore"
let kDBName = "BaplsID.sqlite"
let kJoin = "JoinInitials"

let kPageWidth : CGFloat = 40.0
let kPageHeight : CGFloat = 30.0

let MAXAGENCY : Int = 10
let MAXAGENCYCASE : Int = 13

let kPrintStyle = "PrintStyle"

//MARK:- GLOBAL STRUCTURES

struct Colors {
    static let themeColor = "#87B1CB"
    static let fontColor = "#FFFFFF"
}

struct ScanType {
    static let barcode = "Barcode"
    static let qrCode = "QRCode"
    static let primaryCode = "Primary"
}

struct PrintStyle {
    static let HomeDraw = "HomeDraw"
    static let Forensic = "Forensic"
    static let ALMSC = "ALM/SC/SM"
    static let C19 = "C19"
    static let MC = "MC"
}

struct MenusNames {
    static let scanId = "Scan ID"
    static let search = "Search"
    static let scannedList = "Scanned List"
    static let labelSetting = "Label Setting"
    static let printerSetting = "Printer Setting"
}

struct ScannedDataPrefix {
    static let firstName = "DAC"
    static let familyName = "DCS" // last name
    static let DOB = "DBB"
    static let ENTERTIME = "ENTERTIME"
    static let age = "age"
    static let dateOfIssue = "DBD"
    static let dateOfExpiry = "DBA"
    static let documentNumber = "DAQ"
    static let street = "DAG"
    static let city = "DAI"
    static let state = "DAJ"
    static let postalCode = "DAK"
    static let sex = "DBC"
    static let vehicleClass = "DCA"
    static let endorsement = "DCD"
    static let driverRestriction = "DCB"
    static let currentDateTime = "DateTime"
    
    static let currentDate = "Date"
    static let currentTime = "Time"
    
    static let height = "DAU"
    static let weight = "DAW"
}

struct prefixTitle {
    static let firstName = "First Name"
    static let familyName = "Last Name" // last name
    static let fullName = "Full Name"
    static let fullAddress = "Full Address"
    static let DOB = "Date of Birth"
    static let age = "Age"
    static let dateOfIssue = "Date of Issue"
    static let dateOfExpiry = "Date of Expiry"
    static let documentNumber = "ID"
    static let street = "Street"
    static let city = "City"
    static let state = "State"
    static let postalCode = "Postal Code"
    static let sex = "Sex"
    static let vehicleClass = "Vehicle Class"
    static let endorsement = "Endorsment"
    static let driverRestriction = "Driver Restriction"
    static let currentDateTime = "Drawn Date"
    
    static let currentDate = "Date"
    static let currentTime = "Time"
    
    static let drawnBy = "DrawnBy"
    static let height = "Height"
    static let weight = "Weight"
    static let primaryBarcode = "Scan Text"
    
    static let enterAgency = "Enter Agency"
    static let enterAgencyCase = "Enter Case"
    static let enterTechnicianName = "Enter Technician Name"

}

struct Messages {
    static let ENTER_FIRST_NAME      = "Please Enter First Name"
    static let ENTER_LAST_NAME       = "Please Enter Last Name"
    static let ENTER_VALID_MONTH     = "Please Enter Valid Month"
    static let ENTER_VALID_DAY       = "Please Enter Valid Day"
    static let ENTER_VALID_HOURS     = "Please Enter Valid Hours"
    static let ENTER_VALID_MINUTES   = "Please Enter Valid Minutes"
    static let ENTER_VALID_DOB       = "Please Enter Valid DOB"
    static let SELECT_DOB            = "Please select Date of Birth"
    static let SELECT_DATE_OF_ISSUE  = "Please select Data of Issue"
    static let SELECT_DATE_OF_EXPIRY = "Please select Date of Expiry"
    static let DATA_NOT_FOUND        = "Try Again"
    static let DONE_SUCCESSFULLY     = "Done Successfully"
    static let DUPLICATE_DATA_FOUND  = "Found duplicate data"
    static let CONNECTION_ERROR      = "No Internet Connection"
    static let CARD_STATUS           = "Invalid Card"
    static let ADD_SCAN_DETAIL       = "Enter your scan details"
    static let ENTER_FNAME           = "Enter Firstname"
    static let ENTER_TIME            = "Enter Time (HH:mm)"
    static let ENTER_FAMILY_NAME     = "Enter Lastname"
    static let ENTER_DOB             = "Enter DOB (MM/dd/yyyy)"
    static let ENTER_INITIALS        = "Enter your initials"
    static let PRINT_SUCCESS         = "Print successfully"
    static let PRINT_FAIL            = "Print failed,Try reconnecting printer"
    static let CONNECTION_FAILED     = "Connection failed"
    static let ENTER_AGENCY     = "Please Enter Agency"
    static let ENTER_TECHNICIAN     = "Please Enter Technician Name"
    static let ENTER_AGENCYCASE     = "Please Enter Case"
    static let ENTER_AGENCYANDCASE  = "Please Enter Agency And Case"
    static let ENTER_TECHNICIANNAME  = "Please Enter Technician Name"
    static let AgencyCaseHash = "Case#"
    static let Agency = "Agency"
    static let CollectedBy = "Collected by"
    static let SFPD_QR_SELECT_ALERT = "You can not print QR for SFPD Section"

}

struct ButtonTitle {
    
    static let DONE     = "Done"
    static let CANCEL   = "Cancel"
    static let OK       = "Ok"
    static let UPDATE   = "Update"
}

