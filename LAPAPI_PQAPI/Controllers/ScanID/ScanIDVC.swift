import UIKit
import AVFoundation
import RSBarcodes_Swift
import Crashlytics
import Toast_Swift

class ScanIDVC: RSCodeReaderViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var flashBtnIBO: UIButton!
    @IBOutlet var viewPermission: UIView!
    @IBOutlet weak var scanType: UISegmentedControl!
    @IBOutlet weak var addScanView: UIView!
    @IBOutlet weak var btnAddScanData: UIButton!
    
    //MARK:- GLOBAL VARIABLE
    var txtFieldDOB : UITextField?
    var txtFieldTime : UITextField?
    var barcode: String = ""
    var dispatched: Bool = false
    var isGoVC:Bool?
    var navigation:UINavigationController!
    var selectedScanType : String = ""
    var DOB_Detection_Flag : Bool = false
    var familyName_Detection_Flag : Bool = false
    var firstName_Detection_Flag : Bool = false
    var datePickerView                  = UIDatePicker()
    var selectedDate                    = ""
    var dateSelectionBlock : ((_ date : String) -> Void)!
    let dateFormate                     = "MMddyyyy"
    
    //MARK:- VIEWCONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanType.layer.cornerRadius = 4.0
        selectedScanType = ScanType.barcode
        
        btnAddScanData.setImage(UIImage(named: "ic_addscan")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnAddScanData.tintColor = UIColor.white
        cardView.backgroundColor = UIColor(hexString: Colors.themeColor)
        addScanView.backgroundColor = UIColor(hexString: Colors.themeColor)
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.viewPermission.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.viewPermission.isHidden = false
                        self.viewPermission.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        self.viewPermission.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                        self.view.addSubview(self.viewPermission)
                    }
                }
            })
        }
        self.scanBarcodeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedDate = ""
        self.dispatched = false// reset the flag so user can do another scan
        self.title = MenusNames.scanId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- BUTTON'S ACTIONS
    @IBAction func selectdScanType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            selectedScanType = ScanType.barcode
        }else if sender.selectedSegmentIndex == 1 {
            selectedScanType = ScanType.qrCode
        } else {
            selectedScanType = ScanType.primaryCode
        }
        scanBarcodeView()
    }
    
    @IBAction func btnPermissionClick(_ sender: UIButton) {
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnFlashClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isTorchOn = self.toggleTorch()
        print(isTorchOn)
        //Crashlytics.sharedInstance().crash()
    }
    
    //MARK:- CUSTOM FUNCTION
    
    func scanBarcodeView(){
        
        self.isCrazyMode = true
        
        self.tapHandler = { point in
            print(point)
        }
        
        // NOTE: If you want to detect specific barcode types, you should update the types
        
        var types = self.output.availableMetadataObjectTypes
        
        if selectedScanType == ScanType.barcode {
            types.removeAll(where: {$0 != AVMetadataObject.ObjectType.pdf417})
        }else if selectedScanType == ScanType.qrCode {
            types.removeAll(where: {$0 != AVMetadataObject.ObjectType.qr})
        } else {
            types.removeAll(where: {$0 != AVMetadataObject.ObjectType.code128})
        }
        
        // NOTE: Uncomment the following line remove QRCode scanning capability
        // types = types.filter({ $0 != AVMetadataObject.ObjectType.qr })
        
        self.output.metadataObjectTypes = types
        
        // NOTE: If you layout views in storyboard, you should these 3 lines
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview)
        }
        
        self.barcodesHandler = { barcodes in
            
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes{
                    guard let barcodeString = barcode.stringValue else { continue }
                    self.barcode = barcodeString
                    let detectedData = barcodeString.components(separatedBy: CharacterSet.newlines)
                    //Marks : call to check the scanned data as per model
                    if detectedData.count > 0{
                        self.checkScannedData(rowData: detectedData,barcodeData : barcodeString)
                        print(barcodeString)
                    }
                }
            }
        }
    }
    
    func checkScannedData(rowData : [String],barcodeData : String) {
        
        var tempDisc : [String:String] = [:]
        let labelSetting = Utility.shared.getLabelSettingData()
        
        for detectedString in rowData{
            if detectedString.hasPrefix(ScannedDataPrefix.city) && labelSetting!.city {
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.city, with: "")
                tempDisc[ScannedDataPrefix.city] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.dateOfExpiry) && labelSetting!.dateOfExpiry {
                var fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.dateOfExpiry, with: "")
                fetchStr.insert(string: "/", ind: 2)
                fetchStr.insert(string: "/", ind: 5)
                tempDisc[ScannedDataPrefix.dateOfExpiry] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.dateOfIssue) && labelSetting!.dateOfIssue{
                var fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.dateOfIssue, with: "")
                fetchStr.insert(string: "/", ind: 2)
                fetchStr.insert(string: "/", ind: 5)
                tempDisc[ScannedDataPrefix.dateOfIssue] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.DOB) && labelSetting!.DOB{
                var fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.DOB, with: "")
                fetchStr.insert(string: "/", ind: 2)
                fetchStr.insert(string: "/", ind: 5)
                tempDisc[ScannedDataPrefix.DOB] = fetchStr
                let age = Utility.shared.calculateAge(birthday: fetchStr)
                tempDisc[ScannedDataPrefix.age] = String(age)
                DOB_Detection_Flag = true
            }
            if detectedString.hasPrefix(ScannedDataPrefix.driverRestriction) && labelSetting!.driverRestriction{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.driverRestriction, with: "")
                tempDisc[ScannedDataPrefix.driverRestriction] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.endorsement) && labelSetting!.endorsement{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.endorsement, with: "")
                tempDisc[ScannedDataPrefix.endorsement] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.familyName) && labelSetting!.familyName{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.familyName, with: "")
                tempDisc[ScannedDataPrefix.familyName] = fetchStr
                familyName_Detection_Flag = true
            }
            if detectedString.hasPrefix(ScannedDataPrefix.firstName) && labelSetting!.firstName{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.firstName, with: "")
                tempDisc[ScannedDataPrefix.firstName] = fetchStr
                firstName_Detection_Flag = true
            }
            
            if detectedString.hasPrefix(ScannedDataPrefix.postalCode) && labelSetting!.postalCode{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.postalCode, with: "")
                tempDisc[ScannedDataPrefix.postalCode] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.sex) && labelSetting!.sex{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.sex, with: "")
                tempDisc[ScannedDataPrefix.sex] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.state) && labelSetting!.state{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.state, with: "")
                tempDisc[ScannedDataPrefix.state] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.street) && labelSetting!.street{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.street, with: "")
                tempDisc[ScannedDataPrefix.street] = fetchStr
            }
            if detectedString.hasPrefix(ScannedDataPrefix.vehicleClass) && labelSetting!.vehicleClass{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.vehicleClass, with: "")
                tempDisc[ScannedDataPrefix.vehicleClass] = fetchStr
            }
            if detectedString.contains(ScannedDataPrefix.documentNumber) && labelSetting!.documentNumber{
                let token = detectedString.components(separatedBy: ScannedDataPrefix.documentNumber)
                if token.count > 0{
                    tempDisc[ScannedDataPrefix.documentNumber] = token.last
                }
            }
            if detectedString.hasPrefix(ScannedDataPrefix.height) && labelSetting!.height{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.height, with: "")
                let token = fetchStr.components(separatedBy: "IN")
                if token.count > 0{
                    tempDisc[ScannedDataPrefix.height] = token.first
                }
            }
            if detectedString.hasPrefix(ScannedDataPrefix.weight) && labelSetting!.weight{
                let fetchStr = detectedString.replacingOccurrences(of: ScannedDataPrefix.weight, with: "")
                tempDisc[ScannedDataPrefix.weight] = fetchStr
            }
            
            let formattor = DateFormatter()
            formattor.dateFormat = "MM/dd/yyyy"
            let dt = Date()
            let currentDate = formattor.string(from: dt)
            
            tempDisc[ScannedDataPrefix.currentDateTime] = currentDate
        }
        DispatchQueue.main.async {
            
            self.passScannedData(filteredData: tempDisc, rowData: barcodeData)
            
            //            if tempDisc.keys.contains(ScannedDataPrefix.documentNumber) {
            //                self.passScannedData(filteredData: tempDisc, rowData: barcodeData)
            //            }else{
            //                showAlert(message: Messages.CARD_STATUS, buttonClicked: nil)
            //                self.dispatched = false
            //                self.scanBarcodeView()
            //            }
        }
    }
    @IBAction func btnAddScanDataClick(_ sender: Any) {
        var tempDisc : [String:String] = [:]
        var storeDT = ""
        
        let alert = UIAlertController(title: kAppName, message: Messages.ADD_SCAN_DETAIL, preferredStyle: .alert)
        alert.addTextField { (FamilyNameTextField) in
            FamilyNameTextField.placeholder = Messages.ENTER_FAMILY_NAME
            FamilyNameTextField.autocapitalizationType = .sentences
        }
        alert.addTextField { (FNameTextField) in
            FNameTextField.placeholder = Messages.ENTER_FNAME
            FNameTextField.autocapitalizationType = .sentences
        }
        alert.addTextField { (DOBTextField) in
            
            self.txtFieldDOB = DOBTextField
            self.txtFieldDOB?.keyboardType = .numberPad
            self.txtFieldDOB?.delegate = self
            DOBTextField.placeholder = Messages.ENTER_DOB
            
//            self.datePickerView.datePickerMode = .date
//            if #available(iOS 13.4, *) {
//                self.datePickerView.preferredDatePickerStyle = .wheels
//            } else {
//                // Fallback on earlier versions
//            }
//            self.datePickerView.maximumDate = Date()
            
//            let toolBar           = UIToolbar()
//            toolBar.barStyle      = .default
//            toolBar.isTranslucent = true
//            toolBar.sizeToFit()
            
//            let doneButton = UIBarButtonItem(title: ButtonTitle.DONE, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.datePickerDonePressed))
//            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//            let cancelButton = UIBarButtonItem(title: ButtonTitle.CANCEL, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.datePickerCancelPressed))
            
//            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//            toolBar.isUserInteractionEnabled = true
            
//            DOBTextField.inputView          = self.datePickerView
//            DOBTextField.inputAccessoryView = toolBar
            
//            self.dateSelectionBlock = { (date) in
//                self.view.endEditing(true)
//                if date != ""{
//                    storeDT = date
//                    storeDT.insert(string: "/", ind: 2)
//                    storeDT.insert(string: "/", ind: 5)
//                    alert.textFields?[2].text = storeDT
//                }
//                alert.textFields?[2].resignFirstResponder()
//            }
        }
        
        alert.addTextField { (TimeTextField) in
            self.txtFieldTime = TimeTextField
            self.txtFieldTime?.keyboardType = .numberPad
            self.txtFieldTime?.delegate = self
            TimeTextField.placeholder = Messages.ENTER_TIME
            
        }
        
        alert.addAction(UIAlertAction(title: ButtonTitle.OK, style: .default, handler: { (action) in
            let fname = alert.textFields?[1].text
            let familyname = alert.textFields?[0].text
            let DOB = alert.textFields?[2].text ?? ""
            let Time = alert.textFields?[3].text ?? ""
            
            if familyname != "" && fname != "" && DOB != ""{
                
                if DOB.count == 10{
                    let month = DOB.prefix(2)
                    let index = DOB.index(DOB.startIndex, offsetBy: 3)
                    let endIndex = DOB.index(DOB.endIndex, offsetBy:-5)
                    let day = String(DOB[index..<endIndex])
                    
                    let hour = Time.prefix(2)
                    let minute = Time.suffix(2)
                    
                    let format = DateFormatter()

                    print("\(month),\(day)")
                    
                    if((Int(month) ?? 0) > 12){
                        self.view.makeToast(Messages.ENTER_VALID_MONTH, duration: 2.0, position: .top)
                    }else if((Int(day) ?? 0) > 31){
                        self.view.makeToast(Messages.ENTER_VALID_DAY, duration: 2.0, position: .top)
                    }else if((Int(hour) ?? 0) > 24  && Time != ""){
                        self.view.makeToast(Messages.ENTER_VALID_HOURS, duration: 2.0, position: .top)
                    }else if((Int(minute) ?? 0) > 60 && Time != ""){
                        self.view.makeToast(Messages.ENTER_VALID_MINUTES, duration: 2.0, position: .top)
                    }else{
                        
                        let formattor = DateFormatter()
                        formattor.dateFormat = "MM/dd/yyyy"
                        let dt = Date()
                        let currentDate = formattor.string(from: dt)
                        
                        tempDisc[ScannedDataPrefix.currentDateTime] = currentDate
                        
                        //print("FamilyName : \(familyname ?? ""),FirstName : \(fname ?? ""),DOB : \(DOB ?? "")")
                        tempDisc[ScannedDataPrefix.firstName] = fname?.uppercased()
                        tempDisc[ScannedDataPrefix.familyName] = familyname?.uppercased()
                        tempDisc[ScannedDataPrefix.DOB] = DOB
                        tempDisc[ScannedDataPrefix.ENTERTIME] = Time
                        
                        var makeRowData : String? = ""
                        let discCount = tempDisc.count
                        var count = 0
                        
                        for item in tempDisc {
                            if count != discCount - 1 {
                                if item.value != "" {
                                    if item.key != ScannedDataPrefix.currentDateTime{
                                        if item.key == ScannedDataPrefix.DOB {
                                            makeRowData! += ScannedDataPrefix.DOB + self.selectedDate + "\n"
                                        }else{
                                            makeRowData! += item.key + item.value + "\n"
                                        }
                                    }
                                }
                            }else{
                                if item.value != "" {
                                    if item.key != ScannedDataPrefix.currentDateTime{
                                        if item.key == ScannedDataPrefix.DOB {
                                            makeRowData! += ScannedDataPrefix.DOB + self.selectedDate
                                        }else{
                                            makeRowData! += item.key + item.value
                                        }
                                    }
                                }
                            }
                            count += 1
                        }
                        print(makeRowData!)
                        self.passScannedData(filteredData: tempDisc, rowData: makeRowData ?? "")
                    }
                    
                }else{
                    self.view.makeToast(Messages.ENTER_VALID_DOB, duration: 2.0, position: .top)
                }
                
            }
            self.dispatched = false
        }))
        alert.addAction(UIAlertAction(title: ButtonTitle.CANCEL, style: .cancel, handler: { (action) in
            self.selectedDate = ""
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func datePickerDonePressed() {
        selectedDate = ""
        self.selectedDate = self.datePickerView.date.toString(dateFormat: self.dateFormate)
        if dateSelectionBlock != nil{
            dateSelectionBlock(selectedDate)
        }
        //self.dismiss(animated: true, completion: nil)
        //        self.view.endEditing(true)
    }
    @objc func datePickerCancelPressed() {
        //selectedDate = ""
        //self.dismiss(animated: true, completion: nil)
        //self.view.endEditing(true)
        if dateSelectionBlock != nil{
            dateSelectionBlock(selectedDate)
        }
    }
    
    func passScannedData(filteredData : [String:String],rowData : String) {
        let vc:CustomerInfoVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
        vc.filteredData = filteredData
        vc.rowData = rowData
        vc.selectedScanType = selectedScanType
        DispatchQueue.main.async {
            self.pushTo(viewController: vc, animate: true)
        }
    }
}

//MARK:- EXTENSION STRING

extension String {
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
}

//MARK:- EXTENSION UITEXTFIELD
extension ScanIDVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Format Date of Birth dd-MM-yyyy

            //initially identify your textfield
        
//        showAlert(message: Messages.ENTER_LAST_NAME, arrActionTitles: ["OK"], buttonClicked: nil)

            if textField == txtFieldDOB {
                
                // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
                if (txtFieldDOB?.text?.count == 2) || (txtFieldDOB?.text?.count == 5) {
                    //Handle backspace being pressed
                    if !(string == "") {
                        // append the text
                        txtFieldDOB?.text = (txtFieldDOB?.text)! + "/"
                    }
                }
                // check the condition not exceed 9 chars
                return !(textField.text!.count > 9 && (string.count ) > range.length)
            }else if textField == txtFieldTime {
                // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
                if (txtFieldTime?.text?.count == 2) {
                    //Handle backspace being pressed
                    if !(string == "") {
                        // append the text
                        txtFieldTime?.text = (txtFieldTime?.text)! + ":"
                    }
                }
                // check the condition not exceed 9 chars
                return !(textField.text!.count > 4 && (string.count ) > range.length)
            }
            else {
                return true
            }
        
    }
}
