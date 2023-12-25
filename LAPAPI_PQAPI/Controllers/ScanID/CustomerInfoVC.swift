
import UIKit
import RSBarcodes_Swift
import AVFoundation

enum Printers : String {
    case bluePrinter = "Blue Printer"
    case brownPrinter = "Brown Printer"
}

class CustomerInfoVC: UIViewController,UIPrintInteractionControllerDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tblShowCustomerScannedDetail: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var viewSaveButton: UIView!
    @IBOutlet weak var imgViewBarcode: UIImageView!
    @IBOutlet weak var totalPrintLabel: UILabel!
    @IBOutlet weak var segView: UIView!
    @IBOutlet weak var segOutlet: UISegmentedControl!
    @IBOutlet weak var barcodePrintStatusView: UIView!
    @IBOutlet weak var noofPrintView: UIView!
    @IBOutlet weak var btnBarcodePrintStatus: UIButton!
    @IBOutlet weak var noPrintStepper: UIStepper!
    
    @IBOutlet var txtSelectPrinter: UITextField!
    //MARK:- GLOBAL VARIABLES
    
    var filteredData : [String:String] = [:]
    var rowData : String?
    var arrScannedData : [String] = []
    var homeDrawprinterData : [String] = []
    
    var ForensicprinterFirstLabelData : [String] = []
    var ForensicprinterSecondPartLabelData : String = ""
    var ForensicprinterThirdPartLabelData : [String] = []
    
    var ForensicprinterSecondLabelData : [String] = []
    var currentTime : String = ""
    var currentDate : String = ""
    var isFromSearch = false
    
    var htmlString : String = ""
    var htmlStringSecondPart : String = ""
    var htmlStringThirdPart : String = ""
    
    var htmlStringForSecondLabel : String = ""
    var idLabelString : String = ""
    let labelSetting = Utility.shared.getLabelSettingData()
    var totalPrintCount : Int = 1
    var totalPrintCountForBrown : Int = 1
    var totalPrintCountForBlue : Int = 1
    var firstLabelMaxPrintCount : Int = 1
    var secondLabelMaxPrintCount : Int = 1
    var checkPrintConnection : Bool = true
    var isPrintBarcode : Bool = false
    var takenCount : Int = 1
    var globalfontHeight : CGFloat = 2.4
    var selectedScanType : String = ""
    var agencyStr: String = ""
    var agencyCaseStr: String = ""
    var strTechnicianName: String = ""
    
    var pickerPrinterSelection = UIPickerView()
    var arrPrinter : [Printers] = [Printers.bluePrinter, Printers.brownPrinter]
    var selectedPrinter : Printers = .bluePrinter

    //MARK:- VIEWCONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (defaults.value(forKey: kPrintStyle) == nil){
            defaults.set(PrintStyle.HomeDraw, forKey: kPrintStyle)
        }
        self.navigationItem.title = "Customer Info"
        
        let imgLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imgLogoView.image = UIImage(named: "ic_logo")
        imgLogoView.contentMode = .scaleAspectFit
        imgLogoView.clipsToBounds = true
        imgLogoView.makeCornerRedius(radius: 10.0)
        imgLogoView.backgroundColor = UIColor.clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imgLogoView)
        
        saveButton.makeCornerRedius(radius: self.saveButton.frame.height/2)
        saveButton.backgroundColor = UIColor(hexString: Colors.themeColor)
        saveButton.tintColor = UIColor(hexString: Colors.fontColor)
        printButton.makeCornerRedius(radius: self.printButton.frame.height/2)
        printButton.backgroundColor = UIColor(hexString: Colors.themeColor)
        printButton.tintColor = UIColor(hexString: Colors.fontColor)
        
        self.viewSaveButton.isHidden = true
        
        //        btnBarcodePrintStatus.setBackgroundImage(UIImage(named: "icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        btnBarcodePrintStatus.tintColor = UIColor.blue
        
        //        if self.isFromSearch {
        //            self.rowData                 = self.filteredData.description
        //            self.viewSaveButton.isHidden = true
        //        }
        
        if filteredData.count > 0 {
            genrateBarcode()
            setUpScannedData()
            ForensicDataSetUp()
            print(filteredData)
        }
        LPAPI.enableProgress(false)
        LPAPI.didReadPrinterStateHandler { (code, message) in
            print(code)
            print(message!)
        }
        let status = defaults.value(forKey: kPrintStyle) as? String
        
        if status == PrintStyle.HomeDraw {
            segOutlet.selectedSegmentIndex = 0
            idLabelString.removeAll()
            arrScannedData.removeAll()
            homeDrawprinterData.removeAll()
            setUpScannedData()
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_HOMEDRAW))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_HOMEDRAW)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_HOMEDRAW)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_HOMEDRAW)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_HOMEDRAW))
            
            
        }else if status == PrintStyle.Forensic{
            arrScannedData.removeAll()
            idLabelString.removeAll()
            ForensicprinterFirstLabelData.removeAll()
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterThirdPartLabelData.removeAll()
            ForensicprinterSecondLabelData.removeAll()
            ForensicDataSetUp()
            segOutlet.selectedSegmentIndex = 1
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_SFPD))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_SFPD)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_SFPD)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_SFPD)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_SFPD))
            
        }else if status == PrintStyle.ALMSC{
            arrScannedData.removeAll()
            idLabelString.removeAll()
            ForensicprinterFirstLabelData.removeAll()
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterThirdPartLabelData.removeAll()
            ForensicprinterSecondLabelData.removeAll()
            ForensicDataSetUp()
            segOutlet.selectedSegmentIndex = 2
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_ALMSC))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_ALMSC)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_ALMSC)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_ALMSC)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_ALMSC))
            
        }else if status == PrintStyle.C19{
            segOutlet.selectedSegmentIndex = 3
            arrScannedData.removeAll()
            idLabelString.removeAll()
            homeDrawprinterData.removeAll()
            setUpC19Data()
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_C19))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_C19)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_C19)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_C19)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_C19))
            
        }else if status == PrintStyle.MC{
            arrScannedData.removeAll()
            idLabelString.removeAll()
            ForensicprinterFirstLabelData.removeAll()
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterThirdPartLabelData.removeAll()
            ForensicprinterSecondLabelData.removeAll()
            ForensicDataSetUp()
            segOutlet.selectedSegmentIndex = 4
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_MC))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_MC)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_MC)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_MC)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_MC))
        }
        
        
        // Add inputView in selection of printer
        if #available(iOS 13.0, *) {
            
            txtSelectPrinter.inputView = pickerPrinterSelection
            pickerPrinterSelection.delegate = self
            
            
            let strSelected = UserDefaults.standard.value(forKey: KEY_SELECTED_PRINTER) as? String ?? Printers.bluePrinter.rawValue
            
            selectedPrinter = (strSelected == Printers.brownPrinter.rawValue) ? .brownPrinter : .bluePrinter
            
            txtSelectPrinter.text = selectedPrinter.rawValue
            
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
            
            txtSelectPrinter.rightView = rightView
            txtSelectPrinter.rightViewMode = .always
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    //MARK:- CUSTOM FUNCTION
    
    func setUpScannedData() {
        
        let labelSetting = Utility.shared.getLabelSettingData()
        if filteredData[ScannedDataPrefix.documentNumber] != nil{
            //arrScannedData.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
            idLabelString.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
            //homeDrawprinterData.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
        }
        if labelSetting!.familyName && filteredData[ScannedDataPrefix.familyName] != nil{
            arrScannedData.append("\(prefixTitle.familyName): \(filteredData[ScannedDataPrefix.familyName]!)")
            homeDrawprinterData.append("L: \(filteredData[ScannedDataPrefix.familyName]!)")
        }
        if labelSetting!.firstName && filteredData[ScannedDataPrefix.firstName] != nil{
            arrScannedData.append("\(prefixTitle.firstName): \(filteredData[ScannedDataPrefix.firstName]!)")
            homeDrawprinterData.append("F: \(filteredData[ScannedDataPrefix.firstName]!)")
        }
        if labelSetting!.DOB && filteredData[ScannedDataPrefix.DOB] != nil{
            arrScannedData.append("\(prefixTitle.DOB): \(filteredData[ScannedDataPrefix.DOB]!)")
            homeDrawprinterData.append("DOB: \(filteredData[ScannedDataPrefix.DOB]!)")
        }
        
        if labelSetting!.time && filteredData[ScannedDataPrefix.ENTERTIME] != nil && filteredData[ScannedDataPrefix.ENTERTIME] != ""{
            arrScannedData.append("\(prefixTitle.currentTime): \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
            homeDrawprinterData.append("TIME: \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
        }
        
        if filteredData[ScannedDataPrefix.currentDateTime] != nil {
            let dt = Date()
            let cFormattor = DateFormatter()
            cFormattor.dateFormat = "MM/dd/yyyy HH:mm"
            
            let newDateformattor = DateFormatter()
            newDateformattor.dateFormat = "MM/dd/yyyy"
            currentDate = newDateformattor.string(from: dt)
            
            arrScannedData.append("\(prefixTitle.currentDateTime): \(currentDate)")
            homeDrawprinterData.append("\(prefixTitle.currentDateTime): \(currentDate)")
            
            //let def = UserDefaults()
            if let defValue = defaults.value(forKey: kJoin) as? String{
                arrScannedData.append("\(prefixTitle.drawnBy): \(defValue)")
            }
            
            if selectedScanType == ScanType.primaryCode {
                arrScannedData.append("\(prefixTitle.primaryBarcode): \(rowData ?? "")")
            }
        }
        tblShowCustomerScannedDetail.reloadData()
    }
    
    
    func setUpC19Data() {
        
        let labelSetting = Utility.shared.getLabelSettingData()
        if filteredData[ScannedDataPrefix.documentNumber] != nil{
            //arrScannedData.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
            idLabelString.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
            //homeDrawprinterData.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
        }
        if labelSetting!.familyName && filteredData[ScannedDataPrefix.familyName] != nil{
            arrScannedData.append("\(prefixTitle.familyName): \(filteredData[ScannedDataPrefix.familyName]!)")
            homeDrawprinterData.append("L: \(filteredData[ScannedDataPrefix.familyName]!)")
        }
        if labelSetting!.firstName && filteredData[ScannedDataPrefix.firstName] != nil{
            arrScannedData.append("\(prefixTitle.firstName): \(filteredData[ScannedDataPrefix.firstName]!)")
            homeDrawprinterData.append("F: \(filteredData[ScannedDataPrefix.firstName]!)")
        }
        if labelSetting!.DOB && filteredData[ScannedDataPrefix.DOB] != nil{
            arrScannedData.append("\(prefixTitle.DOB): \(filteredData[ScannedDataPrefix.DOB]!)")
            homeDrawprinterData.append("DOB: \(filteredData[ScannedDataPrefix.DOB]!)")
        }
        if labelSetting!.time && filteredData[ScannedDataPrefix.ENTERTIME] != nil && filteredData[ScannedDataPrefix.ENTERTIME] != ""{
            arrScannedData.append("\(prefixTitle.currentTime): \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
            homeDrawprinterData.append("TIME: \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
        }
        if filteredData[ScannedDataPrefix.currentDateTime] != nil {
            let dt = Date()
            let cFormattor = DateFormatter()
            cFormattor.dateFormat = "MM/dd/yyyy HH:mm"
            
            let newDateformattor = DateFormatter()
            newDateformattor.dateFormat = "MM/dd/yyyy"
            currentDate = newDateformattor.string(from: dt)
            
            arrScannedData.append("\(prefixTitle.currentDate): \(currentDate)")
            homeDrawprinterData.append("\(prefixTitle.currentDate): \(currentDate)")
            
            if selectedScanType == ScanType.primaryCode {
                arrScannedData.append("\(prefixTitle.primaryBarcode): \(rowData ?? "")")
            }
        }
        tblShowCustomerScannedDetail.reloadData()
    }
    
    func ForensicDataSetUp() {
        
        let labelSetting = Utility.shared.getLabelSettingData()
        
        //        if filteredData[ScannedDataPrefix.documentNumber] != nil{
        //            arrScannedData.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
        //            idLabelString.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
        //            ForensicprinterFirstLabelData.append("\(prefixTitle.documentNumber): \(filteredData[ScannedDataPrefix.documentNumber]!)")
        //        }
        if labelSetting!.familyName && filteredData[ScannedDataPrefix.familyName] != nil{
            arrScannedData.append("Last: \(filteredData[ScannedDataPrefix.familyName]!)")
            ForensicprinterFirstLabelData.append("L: \(filteredData[ScannedDataPrefix.familyName]!)")
            ForensicprinterSecondLabelData.append("L: \(filteredData[ScannedDataPrefix.familyName]!)")
        }
        if labelSetting!.firstName && filteredData[ScannedDataPrefix.firstName] != nil{
            arrScannedData.append("First: \(filteredData[ScannedDataPrefix.firstName]!)")
            ForensicprinterFirstLabelData.append("F: \(filteredData[ScannedDataPrefix.firstName]!)")
            ForensicprinterSecondLabelData.append("F: \(filteredData[ScannedDataPrefix.firstName]!)")
        }
        if labelSetting!.DOB && filteredData[ScannedDataPrefix.DOB] != nil{
            arrScannedData.append("DOB: \(filteredData[ScannedDataPrefix.DOB]!)")
            ForensicprinterFirstLabelData.append("DOB: \(filteredData[ScannedDataPrefix.DOB]!)")
            ForensicprinterSecondLabelData.append("DOB: \(filteredData[ScannedDataPrefix.DOB]!)")
        }
        
        if labelSetting!.time && filteredData[ScannedDataPrefix.ENTERTIME] != nil && filteredData[ScannedDataPrefix.ENTERTIME] != ""{
            arrScannedData.append("Time: \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
//            ForensicprinterFirstLabelData.append("Time: \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
//            ForensicprinterSecondLabelData.append("Time: \(filteredData[ScannedDataPrefix.ENTERTIME]!)")
        }
        
        //let def = UserDefaults()
        if let defValue = defaults.value(forKey: kJoin) as? String{
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterSecondPartLabelData.append("\u{21E6} Initials / Taken by: \(defValue)")
        }
        //        if labelSetting!.firstName && filteredData[ScannedDataPrefix.firstName] != nil || labelSetting!.familyName && filteredData[ScannedDataPrefix.familyName] != nil {
        //            let firstNamePrefix = filteredData[ScannedDataPrefix.firstName]!.first
        //            let familyName = "." + filteredData[ScannedDataPrefix.familyName]!
        //            ForensicprinterFirstLabelData.append("Taken by: \(firstNamePrefix!)\(familyName)")
        //        }
        
        if labelSetting!.sex && filteredData[ScannedDataPrefix.sex] != nil{
            if filteredData[ScannedDataPrefix.sex] == "1" {
                arrScannedData.append("Gender: Male")
                ForensicprinterSecondLabelData.append("Gender: M")
            }else{
                arrScannedData.append("Gender: Female")
                ForensicprinterSecondLabelData.append("Gender: F")
            }
        }else{
            ForensicprinterSecondLabelData.append("Gender: ")
        }
        
        if filteredData[ScannedDataPrefix.currentDateTime] != nil{
            //arrScannedData.append("\(prefixTitle.weight): \(filteredData[ScannedDataPrefix.weight]!)")
            
            let status = defaults.value(forKey: kPrintStyle) as? String
            
            if status == PrintStyle.MC{
                ForensicprinterThirdPartLabelData.append("DATE: \(filteredData[ScannedDataPrefix.currentDateTime]!)  TIME: \(filteredData[ScannedDataPrefix.ENTERTIME] ?? "")")
            }else{
                ForensicprinterThirdPartLabelData.append("Date & Time:")
                ForensicprinterThirdPartLabelData.append("\(filteredData[ScannedDataPrefix.currentDateTime]!) @ \(filteredData[ScannedDataPrefix.ENTERTIME] ?? "")")
            }
            
            
//            ForensicprinterThirdPartLabelData.append("\(prefixTitle.currentDate): \(filteredData[ScannedDataPrefix.currentDateTime]!)")
//            ForensicprinterThirdPartLabelData.append("\(prefixTitle.currentTime)(24h): ")
            
            //ForensicprinterFirstLabelData.append("\(prefixTitle.currentDate): \(filteredData[ScannedDataPrefix.currentDateTime]!)")
            //ForensicprinterFirstLabelData.append("\(prefixTitle.currentTime)(24h): ")
        }
        
        if labelSetting!.weight && filteredData[ScannedDataPrefix.weight] != nil{
            arrScannedData.append("\(prefixTitle.weight): \(filteredData[ScannedDataPrefix.weight]!)")
            ForensicprinterSecondLabelData.append("\(prefixTitle.weight): \(filteredData[ScannedDataPrefix.weight]!) lbs")
        }else{
            ForensicprinterSecondLabelData.append("\(prefixTitle.weight): ")
        }
        if labelSetting!.height && filteredData[ScannedDataPrefix.height] != nil{
            guard let inch = filteredData[ScannedDataPrefix.height] else { return }
            let myString = inch
            guard let trimInch = Int(myString.replacingOccurrences(of: " ", with: "")) else { return }
            let feet = Float(trimInch) / 12.0
            let roundValue = String(format: "%.2f", feet)
            
            let token = roundValue.components(separatedBy: ".")
            if token.count > 0{
                guard let feetFirst = token.first else { return }
                guard let feetPoint = Int(token.last!) else { return }
                let rounded = String((Float(feetPoint) * 12.0 / 100.0).rounded())
                let tokenRound = rounded.components(separatedBy: ".")
                if tokenRound.count > 0{
                    let tempFeet = feetFirst + "'" + tokenRound.first!
                    let finalFeet = tempFeet + "\""//"\u{22}"
                    arrScannedData.append("\(prefixTitle.height): \(finalFeet)")
                    ForensicprinterSecondLabelData.append("\(prefixTitle.height): \(finalFeet)")
                }
            }
        }else{
            ForensicprinterSecondLabelData.append("\(prefixTitle.height): ")
        }
        tblShowCustomerScannedDetail.reloadData()
    }
    func storeDataServer(params : [String:String]) {
        if isConnectedToInternet(withAlert: true){
            showProgressIn(viewcotroller: self)
            apiManager.callJsonRequest(strURL: STORE_DATA_URL, httpMethod:.post, params: params) {(response, error) in
                DispatchQueue.main.async {
                    hideProgress()
                }
            }
        }
    }
    func genrateBarcode(){
        
        if let barcodeRowData = self.rowData {
            let gen = RSUnifiedCodeGenerator.shared
            var codeType = ""
            if selectedScanType == "" {
                codeType = self.isFromSearch ? AVMetadataObject.ObjectType.qr.rawValue : AVMetadataObject.ObjectType.pdf417.rawValue
            } else {
                if selectedScanType == ScanType.barcode {
                    codeType = AVMetadataObject.ObjectType.pdf417.rawValue

                } else if selectedScanType == ScanType.qrCode {
                    codeType = AVMetadataObject.ObjectType.qr.rawValue
                    
                } else if selectedScanType == ScanType.primaryCode {
                    codeType = AVMetadataObject.ObjectType.code128.rawValue
                    
                }
            }
            if let image = gen.generateCode(barcodeRowData, machineReadableCodeObjectType: codeType){
                self.imgViewBarcode.layer.borderWidth = 0
                self.imgViewBarcode.image = RSAbstractCodeGenerator.resizeImage(image, targetSize: self.imgViewBarcode.bounds.size, contentMode: UIView.ContentMode.scaleAspectFit)
            }
        }
    }
    func sqlFrom(dict : [String : String], for table : String) -> String {
        let keys = dict.keys.joined(separator: ", ")
        var values = dict.values.joined(separator: "', '")
        values = "'\(values)'"
        let sql = "INSERT INTO \(table) ( \(keys) ) VALUES ( \( values) )"
        print(sql)
        return sql
    }
    
    //MARK:- BUTTON'S ACTION
    
    @IBAction func printBarcodeButtonTapped(_ sender: Any) {
        
//        if self.segOutlet.selectedSegmentIndex == 1{
//            showAlert(message: Messages.SFPD_QR_SELECT_ALERT, arrActionTitles: ["OK"], buttonClicked: nil)
//            return
//        }
        
        if isPrintBarcode {
            btnBarcodePrintStatus.setBackgroundImage(UIImage(named: "icon"), for: .normal)
            isPrintBarcode = false
        }else{
            btnBarcodePrintStatus.setBackgroundImage(UIImage(named: "check-box"), for: .normal)
            isPrintBarcode = true
        }
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        let strQuery = "select * from \(kTableName) where \(ScannedDataPrefix.documentNumber)='\(filteredData[ScannedDataPrefix.documentNumber]!)'"
        let result = SqliteManager.shared.SelectQuery(strQuery)
        if result.count > 0 {
            showAlert(message: Messages.DUPLICATE_DATA_FOUND, buttonClicked: nil)
        }else{
            let query = sqlFrom(dict: filteredData, for: kTableName)
            let status = SqliteManager.shared.DMLExecuteQuery(query)
            if status {
                showAlert(message: Messages.DONE_SUCCESSFULLY) { (action) in
                    self.viewSaveButton.isHidden = true
                    self.storeDataServer(params: self.filteredData)
                }
            }
        }
    }
    @IBAction func segSelection(_ sender: UISegmentedControl) {
        firstLabelMaxPrintCount = 6
        secondLabelMaxPrintCount = 2
        //takenCount = 1
        self.agencyStr = ""
        self.agencyCaseStr = ""
        
        if sender.selectedSegmentIndex == 0 {
            defaults.setValue(PrintStyle.HomeDraw, forKey: kPrintStyle)
            arrScannedData.removeAll()
            idLabelString.removeAll()
            homeDrawprinterData.removeAll()
            setUpScannedData()
                        
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_HOMEDRAW))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_HOMEDRAW)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_HOMEDRAW)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_HOMEDRAW)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_HOMEDRAW))

            
        }else if sender.selectedSegmentIndex == 1 {
            defaults.setValue(PrintStyle.Forensic, forKey: kPrintStyle)
            arrScannedData.removeAll()
            idLabelString.removeAll()
            ForensicprinterFirstLabelData.removeAll()
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterThirdPartLabelData.removeAll()
            ForensicprinterSecondLabelData.removeAll()
            ForensicDataSetUp()
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_SFPD))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_SFPD)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_SFPD)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_SFPD)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_SFPD))

            
 //           self.strTechnicianName = ""
//            let vc: ALMSCVC = Utility.pushToViewParam(sb: "HomeSB", currentVC: self, nextVC: String(describing: ALMSCVC.self)) as! ALMSCVC
//            vc.modalPresentationStyle = .overFullScreen
//            vc.addedAgency = { agency, agencycase in
//                print(agency)
//                self.strTechnicianName = agency
////                    print(agencycase)
////                    self.agencyStr = agency
////                    self.agencyCaseStr = agencycase
//            }
//            self.present(vc, animated: true)
        } else if sender.selectedSegmentIndex == 2 {
            defaults.setValue(PrintStyle.ALMSC, forKey: kPrintStyle)
            arrScannedData.removeAll()
            idLabelString.removeAll()
            ForensicprinterFirstLabelData.removeAll()
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterThirdPartLabelData.removeAll()
            ForensicprinterSecondLabelData.removeAll()
            ForensicDataSetUp()
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_ALMSC))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_ALMSC)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_ALMSC)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_ALMSC)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_ALMSC))

            
//            self.strTechnicianName = ""
//            let vc: ALMSCVC = Utility.pushToViewParam(sb: "HomeSB", currentVC: self, nextVC: String(describing: ALMSCVC.self)) as! ALMSCVC
//            vc.modalPresentationStyle = .overFullScreen
//            vc.addedAgency = { agency, agencycase in
//                print(agency)
//                self.strTechnicianName = agency
////                    print(agencycase)
////                    self.agencyStr = agency
////                    self.agencyCaseStr = agencycase
//            }
//            self.present(vc, animated: true)
        } else if sender.selectedSegmentIndex == 3 {
            defaults.setValue(PrintStyle.C19, forKey: kPrintStyle)
            arrScannedData.removeAll()
            idLabelString.removeAll()
            homeDrawprinterData.removeAll()
            setUpC19Data()
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_C19))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_C19)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_C19)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_C19)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_C19))
            
        }else if sender.selectedSegmentIndex == 4 {
            defaults.setValue(PrintStyle.MC, forKey: kPrintStyle)
            arrScannedData.removeAll()
            idLabelString.removeAll()
            ForensicprinterFirstLabelData.removeAll()
            ForensicprinterSecondPartLabelData.removeAll()
            ForensicprinterThirdPartLabelData.removeAll()
            ForensicprinterSecondLabelData.removeAll()
            ForensicDataSetUp()
            
            totalPrintLabel.text = "No.of Print: " + String(getDefaultCountOfSection(key: .KEY_MC))
            totalPrintCount = getDefaultCountOfSection(key: .KEY_MC)
            totalPrintCountForBrown = getDefaultCountOfSection(key: .KEY_MC)
            totalPrintCountForBlue = getDefaultCountOfSection(key: .KEY_MC)
            noPrintStepper.value = Double(getDefaultCountOfSection(key: .KEY_MC))
            
        }
    }
    
    //MARK:- STEPPER'S ACTION
    
    @IBAction func stepperValueChange(_ sender: UIStepper) {
        totalPrintLabel.text = "No.of Print: " + String(Int(sender.value))
//        totalPrintCount = Int(sender.value)
        firstLabelMaxPrintCount = Int(sender.value)
        totalPrintCountForBrown = Int(sender.value)
        totalPrintCountForBlue = Int(sender.value)
        
        switch segOutlet.selectedSegmentIndex {
        case 0:
            setDefaultCountOfSection(key: .KEY_HOMEDRAW, count: totalPrintCount)
            break
        case 1:
            setDefaultCountOfSection(key: .KEY_SFPD, count: totalPrintCount)
            break
        case 2:
            setDefaultCountOfSection(key: .KEY_ALMSC, count: totalPrintCount)
            break
        case 3:
            setDefaultCountOfSection(key: .KEY_C19, count: totalPrintCount)
            break
        case 4:
            setDefaultCountOfSection(key: .KEY_MC, count: totalPrintCount)
            break
        default:
            break
        }
        
        
    }
    
    //MARK:- PRINTING FUNCTIONALITY ALL
    
    @IBAction func printButtonTapped(_ sender: Any) {
        
//        let alertSheet = UIAlertController(title: "Printers", message: "Select the printer which you want to print?", preferredStyle: .actionSheet)
//
//        let bluePrinterAction = UIAlertAction(title: "Blue Printer", style: .default) { action in
//            self.selectedPrinter(printer: .bluePrinter)
//        }
//
//        let brownPrinterAction = UIAlertAction(title: "Brown Printer", style: .default) { action in
//            self.selectedPrinter(printer: .brownPrinter)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
//        }
//
//        alertSheet.addAction(bluePrinterAction)
//        alertSheet.addAction(brownPrinterAction)
//        alertSheet.addAction(cancelAction)
//
//        self.present(alertSheet, animated: true)
        
        self.selectedPrinter(printer: selectedPrinter)
        
    }
    
    func selectedPrinter(printer:Printers){
        
        let status = defaults.value(forKey: kPrintStyle) as? String
   
//        if (status == PrintStyle.ALMSC || status == PrintStyle.Forensic) && (self.strTechnicianName == "") {
//
//            DispatchQueue.main.async {
//                showAlert(message: Messages.ENTER_TECHNICIANNAME , buttonClicked: nil)
//
////                let vc: ALMSCVC = Utility.pushToViewParam(sb: "HomeSB", currentVC: self, nextVC: String(describing: ALMSCVC.self)) as! ALMSCVC
////                vc.modalPresentationStyle = .overFullScreen
////                vc.addedAgency = { agency, agencycase in
////                    print(agency)
////                    self.strTechnicianName = agency
//////                    print(agencycase)
//////                    self.agencyStr = agency
//////                    self.agencyCaseStr = agencycase
////                }
////                self.present(vc, animated: true)
//            }
//        }
//        else {
        let dt = Date()
        let newTimeformattor = DateFormatter()
        newTimeformattor.dateFormat = "HH:mm"
        currentTime = newTimeformattor.string(from: dt)
        
        totalPrintCount = Int(noPrintStepper.value)
        totalPrintCountForBrown = Int(noPrintStepper.value)
        totalPrintCountForBlue = Int(noPrintStepper.value)
//        firstLabelMaxPrintCount = 6
//        secondLabelMaxPrintCount = 2
        
        if appDelegate.isForUser {
            if appDelegate.isPrinterAvailable {
                printLabel(printer: printer)
            }else{
                
                if(printer == .bluePrinter){
                    LPAPI.scanPrinters(true, completion: nil) { (success) in
                        if success{
                            DispatchQueue.main.async {
                                appDelegate.isPrinterAvailable = true
                                self.printLabel(printer: printer)
                            }
                        }else{
                            DispatchQueue.main.async {
                                showAlert(message: Messages.CONNECTION_FAILED, buttonClicked: nil)
                            }
                        }
                    }
                }else{
                    let vc: BluetoothListVC = Utility.pushToViewParam(sb: "HomeSB", currentVC: self, nextVC: String(describing: BluetoothListVC.self)) as! BluetoothListVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.printClosure = { printBool in
                        if printBool{
                            self.printLabel(printer: printer)
                        }
                    }
                    self.present(vc, animated: true)
                }
                
            }
        }else{
            printLabel(printer: printer)
        }
//        }
        
    }
    
    func printLabel(printer:Printers) {
        //let def = UserDefaults()
        if let defValue = defaults.value(forKey: kJoin) as? String{
            
            if(printer == .bluePrinter){
                isInitialsFoundForBluePrinter(joinString: defValue)
            }else{
                isInitialsFoundForBrownPrinter(joinString: defValue)
            }
            
        }else{
            isInitialsNotFound(printer: printer)
        }
    }
    
    func estimatedLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        return rectangleHeight
    }
    
    func isInitialsFoundForBluePrinter(joinString : String) {
        let status = defaults.value(forKey: kPrintStyle) as? String
        if checkPrintConnection {
           // print(totalPrintCount)
//            if totalPrintCount > 0 {
               // print(firstLabelMaxPrintCount)
                if totalPrintCountForBlue >= 1 {
                    
                    self.makeHtmlString()
                    print("=====firstLabelMaxPrintCount :\(totalPrintCountForBlue)=====")
                    print(self.htmlString)
                    
                    var labelHeight : CGFloat = 0.0
                    
                    if status == PrintStyle.HomeDraw {
                        self.totalPrintCount -= 1
                        firstLabelMaxPrintCount = 1
                        secondLabelMaxPrintCount = 0
                        labelHeight = 17.0
                    }else if status == PrintStyle.ALMSC || status == PrintStyle.C19 || status == PrintStyle.MC {
                        self.totalPrintCount -= 1
                        firstLabelMaxPrintCount = 1
                        secondLabelMaxPrintCount = 0
                        labelHeight = 17.0
                    }else{
                        firstLabelMaxPrintCount -= 1
                        labelHeight = 19.0
                    }
                    totalPrintCountForBlue -= 1
                    LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
                    LPAPI.setItemHorizontalAlignment(0)
                    
                    let firstLabelY = estimatedLabelHeight(text: htmlString, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight))
                    if(status != PrintStyle.MC){
                        LPAPI.drawText(self.htmlString, x: 1, y: 2, width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        LPAPI.setPrintDarkness(15)
                    }
                    
                    if ((status == PrintStyle.ALMSC) || (status == PrintStyle.Forensic)){
                        print(self.htmlStringSecondPart) //DATE & TIME OF COLLECTION (24h) 01/05/2023 @
                        //print(self.htmlStringThirdPart) //Collected by: O.NEW
                        
                        let secondLabelY = estimatedLabelHeight(text: htmlString, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight)) + (htmlString == "" ? 2 : 4)
                        LPAPI.drawText(self.htmlStringSecondPart, x: 1, y: secondLabelY - 1.5, width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        
//                        let thirdLabelY = estimatedLabelHeight(text: htmlStringSecondPart, width: kPageWidth, font: .systemFont(ofSize: 1.5))
                        
                        let strTechnicianAndWitness = "Tech: \(defaults.value(forKey: kJoin) as? String ?? "")\nWitness:"
                        print(strTechnicianAndWitness)
                        var textForLabelTextHeight = (htmlString + self.htmlStringSecondPart + strTechnicianAndWitness)
                        
                        let techWitLabelY = estimatedLabelHeight(text: textForLabelTextHeight, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight)) + 3
                        LPAPI.drawText(strTechnicianAndWitness, x: 1, y: techWitLabelY - 1 , width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        
                    }else if status == PrintStyle.MC{
                        print(self.htmlStringSecondPart) //DATE & TIME
                        
                        let title = "CALIFORNIA DEPT. OF JUSTICE"
                        let titleLabelY = estimatedLabelHeight(text: title, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight))
                        LPAPI.drawText(title, x: 1, y: 2, width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        
                        if(htmlString != ""){
                            let firstLabelYY = estimatedLabelHeight(text: title, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight)) + (htmlString == "" ? 1 : 2)
                            LPAPI.drawText(self.htmlString, x: 1, y: firstLabelYY , width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        }
                        
                        let strInitial = "INITIALS OF PERSON:\n"
                        let strDrawing = "DRAWING OF BLOOD/ OR \nWITNESS TO URINE\n"
                        let strMerge = strInitial + strDrawing + htmlStringSecondPart
                        //print(self.htmlStringSecondPart) //DATE & TIME OF COLLECTION (24h) 01/05/2023 @
                        //print(self.htmlStringThirdPart) //Collected by: O.NEW
                        
                        let txtForLable = strMerge + title
                        let secondLabelY = estimatedLabelHeight(text: txtForLable, width: kPageWidth, font: .systemFont(ofSize: 1.8))
                        LPAPI.drawText(strMerge, x: 1, y: secondLabelY - (htmlString != "" ? 1 : 3) , width: kPageWidth - 1, height: labelHeight, fontHeight: 1.8)
                        
                        let strWit = "WITNESSING OFFICER:\nBFS-40"
//                        let lastStr = txtForLable + "\n" + strWit
                        let thirdLabelY = estimatedLabelHeight(text: strWit, width: kPageWidth, font: .systemFont(ofSize: 1.8)) + 3.5
                        LPAPI.drawText(strWit, x: 1, y: secondLabelY + thirdLabelY  , width: kPageWidth - 1, height: labelHeight, fontHeight: 1.8)
                               
                    }else{
                        LPAPI.drawLineWith(x: 21, y: firstLabelY + 2, width: kPageWidth - 33, height: 0.25) // horizontal line
                    }
                    
                    //let image = LPAPI.endDraw()
                    
                    if appDelegate.isForUser {
                        
                            LPAPI.endDraw()
                            LPAPI.print { (success) in
                                
                                if success{
                                }else{
                                    self.checkPrintConnection = false
                                }
                                DispatchQueue.main.async {
                                    //let def = UserDefaults()
                                    if let defValue = defaults.value(forKey: kJoin) as? String{
                                        self.isInitialsFoundForBluePrinter(joinString: defValue)
                                    }
                                }
                            }
                        
                    }else{
                        let image = LPAPI.endDraw()
                        DispatchQueue.main.async {
                            //let def = UserDefaults()
                            if let defValue = defaults.value(forKey: kJoin) as? String{
                                self.isInitialsFoundForBluePrinter(joinString: defValue)
                            }
                        }
                    }
                }else {
                    if self.isPrintBarcode{
                        LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
                        LPAPI.setItemHorizontalAlignment(0)
                        LPAPI.drawText(self.idLabelString, x: 12, y: 1, width: kPageWidth - 8.0, height: 15.0, fontHeight: globalfontHeight)
                        var rowData1 = ""
                        if status == PrintStyle.ALMSC && (self.agencyStr != "") && (self.agencyCaseStr != "") {
                            // ALM/SC Option
                            rowData1 = (self.rowData ?? "") + "\n" + self.agencyStr + "\n" + self.agencyCaseStr
                        } else {
                            rowData1 = (self.rowData ?? "")
                        }
                        LPAPI.drawQRCode(rowData1, x: 11, y: 4, width: 18, height: 18, eccLevel: 0, autoResetWidth: true)
                        
                        //let image = LPAPI.endDraw()
                        
                        if appDelegate.isForUser {
                            
                                LPAPI.endDraw()
                                LPAPI.print { (success) in
                                    if success{
                                    }else{
                                        self.checkPrintConnection = false
                                    }
                                }

                        }else{
                            let image = LPAPI.endDraw()
                        }
                    }
//                    self.totalPrintCount -= 1
//                    self.totalPrintCountForBlue = Int(noPrintStepper.value)
//                    self.firstLabelMaxPrintCount = Int(noPrintStepper.value)
//                    self.secondLabelMaxPrintCount = 2
//                    DispatchQueue.main.async {
//                        //let def = UserDefaults()
//                        if let defValue = defaults.value(forKey: kJoin) as? String{
//                            self.isInitialsFoundForBluePrinter(joinString: defValue)
//                        }
//                    }
                    if totalPrintCountForBlue == 0{
                        DispatchQueue.main.async {
                            showAlert(message: Messages.PRINT_SUCCESS, buttonClicked: { (action) in})
                        }
                    }
                }
//            }
//            else if (status ?? "") == PrintStyle.HomeDraw {
//
//                self.totalPrintCount -= 1
//                if self.isPrintBarcode{
//                    LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
//                    LPAPI.setItemHorizontalAlignment(0)
//                    LPAPI.drawText(self.idLabelString, x: 12, y: 1, width: kPageWidth - 8.0, height: 15.0, fontHeight: globalfontHeight)
//
//                    LPAPI.drawQRCode(self.rowData, x: 11, y: 4, width: 18, height: 18, eccLevel: 0, autoResetWidth: true)
//
//                    //let image = LPAPI.endDraw()
//
//                    if appDelegate.isForUser {
//
//                            LPAPI.endDraw()
//                            LPAPI.print { (success) in
//                                if success{
//                                }else{
//                                    self.checkPrintConnection = false
//                                }
//                                DispatchQueue.main.async {
//                                    showAlert(message: Messages.PRINT_SUCCESS, buttonClicked: { (action) in})
//                                }
//                            }
//
//                    }else{
//                        let image = LPAPI.endDraw()
//                    }
//                }else{
////                    DispatchQueue.main.async {
////                        showAlert(message: Messages.PRINT_SUCCESS, buttonClicked: { (action) in})
////                    }
//                }
//            }
        }else{
            DispatchQueue.main.async {
                showAlert(message: Messages.PRINT_FAIL, buttonClicked: { (action) in
                        LPAPI.scanPrinters(true, completion: nil) { (success) in
                            if success{
                                DispatchQueue.main.async {
                                    appDelegate.isPrinterAvailable = true
                                    self.printLabel(printer: .bluePrinter)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    showAlert(message: Messages.CONNECTION_FAILED, buttonClicked: nil)
                                }
                            }
                        }
                })
            }
        }
    }
    
    func isInitialsFoundForBrownPrinter(joinString : String) {
        let status = defaults.value(forKey: kPrintStyle) as? String
        if checkPrintConnection {
           // print(totalPrintCount)
//            if totalPrintCountForBrown > 0 {
               // print(firstLabelMaxPrintCount)
//                if firstLabelMaxPrintCount >= 1 {
                    
                    self.makeHtmlString()
                    print("=====firstLabelMaxPrintCount :\(firstLabelMaxPrintCount)=====")
                    print(self.htmlString)
                    
                    var labelHeight : CGFloat = 0.0
                    
                    if status == PrintStyle.HomeDraw {
                        self.totalPrintCountForBrown -= 1
//                        firstLabelMaxPrintCount = 1
//                        secondLabelMaxPrintCount = 0
                        labelHeight = 17.0
                    }else if status == PrintStyle.ALMSC || status == PrintStyle.C19 || status == PrintStyle.MC {
                        self.totalPrintCountForBrown -= 1
//                        firstLabelMaxPrintCount = 1
//                        secondLabelMaxPrintCount = 0
                        labelHeight = 17.0
                    }else{
//                        firstLabelMaxPrintCount -= 1
                        labelHeight = 19.0
                    }
                    LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
                    LPAPI.setItemHorizontalAlignment(0)
                    
                    let firstLabelY = estimatedLabelHeight(text: htmlString, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight))
                    if(status != PrintStyle.MC){
                        LPAPI.drawText(self.htmlString, x: 1, y: 2, width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        LPAPI.setPrintDarkness(15)
                    }
                    
                    if ((status == PrintStyle.ALMSC) || (status == PrintStyle.Forensic)){
                        print(self.htmlStringSecondPart) //DATE & TIME OF COLLECTION (24h) 01/05/2023 @
                        //print(self.htmlStringThirdPart) //Collected by: O.NEW
                        
                        let secondLabelY = estimatedLabelHeight(text: htmlString, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight)) + (htmlString == "" ? 2 : 4)
                        LPAPI.drawText(self.htmlStringSecondPart, x: 1, y: secondLabelY - 1.5, width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        
//                        let thirdLabelY = estimatedLabelHeight(text: htmlStringSecondPart, width: kPageWidth, font: .systemFont(ofSize: 1.5))
                        
                        let strTechnicianAndWitness = "Tech: \(defaults.value(forKey: kJoin) as? String ?? "")\nWitness:"
                        print(strTechnicianAndWitness)
                        var textForLabelTextHeight = (htmlString + self.htmlStringSecondPart + strTechnicianAndWitness)
                        
                        let techWitLabelY = estimatedLabelHeight(text: textForLabelTextHeight, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight)) + 3
                        LPAPI.drawText(strTechnicianAndWitness, x: 1, y: techWitLabelY - 1 , width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        
                    }else if status == PrintStyle.MC{
                        print(self.htmlStringSecondPart) //DATE & TIME
                        
                        let title = "CALIFORNIA DEPT. OF JUSTICE"
                        let titleLabelY = estimatedLabelHeight(text: title, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight))
                        LPAPI.drawText(title, x: 1, y: 2, width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        
                        if(htmlString != ""){
                            let firstLabelYY = estimatedLabelHeight(text: title, width: kPageWidth, font: .systemFont(ofSize: globalfontHeight)) + (htmlString == "" ? 1 : 2)
                            LPAPI.drawText(self.htmlString, x: 1, y: firstLabelYY , width: kPageWidth - 1, height: labelHeight, fontHeight: globalfontHeight)
                        }
                        
                        let strInitial = "INITIALS OF PERSON:\n"
                        let strDrawing = "DRAWING OF BLOOD/ OR \nWITNESS TO URINE\n"
                        let strMerge = strInitial + strDrawing + htmlStringSecondPart
                        //print(self.htmlStringSecondPart) //DATE & TIME OF COLLECTION (24h) 01/05/2023 @
                        //print(self.htmlStringThirdPart) //Collected by: O.NEW
                        
                        let txtForLable = strMerge + title
                        let secondLabelY = estimatedLabelHeight(text: txtForLable, width: kPageWidth, font: .systemFont(ofSize: 1.8))
                        LPAPI.drawText(strMerge, x: 1, y: secondLabelY - (htmlString != "" ? 1 : 3) , width: kPageWidth - 1, height: labelHeight, fontHeight: 1.8)
                        
                        let strWit = "WITNESSING OFFICER:\nBFS-40"
//                        let lastStr = txtForLable + "\n" + strWit
                        let thirdLabelY = estimatedLabelHeight(text: strWit, width: kPageWidth, font: .systemFont(ofSize: 1.8)) + 3.5
                        LPAPI.drawText(strWit, x: 1, y: secondLabelY + thirdLabelY  , width: kPageWidth - 1, height: labelHeight, fontHeight: 1.8)
                               
                    }else{
                        LPAPI.drawLineWith(x: 21, y: firstLabelY + 2, width: kPageWidth - 33, height: 0.25) // horizontal line
                    }
                    
                    //let image = LPAPI.endDraw()
                    
                    if appDelegate.isForUser {
                        
                        let imageLabel = LPAPI.endDraw()
                        
                        if self.isPrintBarcode{
                            LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
                            LPAPI.setItemHorizontalAlignment(0)
                            LPAPI.drawText(self.idLabelString, x: 12, y: 1, width: kPageWidth - 8.0, height: 15.0, fontHeight: globalfontHeight)
                            var rowData1 = ""
                            if status == PrintStyle.ALMSC && (self.agencyStr != "") && (self.agencyCaseStr != "") {
                                // ALM/SC Option
                                rowData1 = (self.rowData ?? "") + "\n" + self.agencyStr + "\n" + self.agencyCaseStr
                            } else {
                                rowData1 = (self.rowData ?? "")
                            }
                            LPAPI.drawQRCode(rowData1, x: 11, y: 4, width: 18, height: 18, eccLevel: 0, autoResetWidth: true)
                            
                            let imgQR = LPAPI.endDraw()
                            
                            print("totalCounttttt:\(Int(noPrintStepper.value))")
                            let count = Int(noPrintStepper.value)
                            recursivePrintCallForQR(imageDetail: imageLabel ?? UIImage(), imageQR: imgQR ?? UIImage(), printCount: count*2)
                        }else{
                            print("totalCounttttt:\(Int(noPrintStepper.value))")
                            let count = Int(noPrintStepper.value)
                            recursivePrintCall(image: imageLabel ?? UIImage(), printCount: count)
                        }

                        
                            

                    }else{
                        let image = LPAPI.endDraw()
                        DispatchQueue.main.async {
                            //let def = UserDefaults()
                            if let defValue = defaults.value(forKey: kJoin) as? String{
                                self.isInitialsFoundForBrownPrinter(joinString: defValue)
                            }
                        }
                    }
//                }
//                else {
////                    if self.isPrintBarcode{
////                        LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
////                        LPAPI.setItemHorizontalAlignment(0)
////                        LPAPI.drawText(self.idLabelString, x: 12, y: 1, width: kPageWidth - 8.0, height: 15.0, fontHeight: globalfontHeight)
////                        var rowData1 = ""
////                        if status == PrintStyle.ALMSC && (self.agencyStr != "") && (self.agencyCaseStr != "") {
////                            // ALM/SC Option
////                            rowData1 = (self.rowData ?? "") + "\n" + self.agencyStr + "\n" + self.agencyCaseStr
////                        } else {
////                            rowData1 = (self.rowData ?? "")
////                        }
////                        LPAPI.drawQRCode(rowData1, x: 11, y: 4, width: 18, height: 18, eccLevel: 0, autoResetWidth: true)
////
////                        //let image = LPAPI.endDraw()
////
////                        if appDelegate.isForUser {
////
////                                let image = LPAPI.endDraw()
////
//////                                let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
//////                                imageview.backgroundColor = .lightGray
//////                                imageview.image = image
//////                                self.view.addSubview(imageview)
////
////                                PQAPI.print(image, width: Int(kPageWidth), height: Int(kPageHeight)) { success in
////
////                                    if success{
////
////                                        //self.checkPrintConnection = true
////                                    }else{
////                                        //self.checkPrintConnection = false
////                                    }
////                                }
////
////
////                        }else{
////                            let image = LPAPI.endDraw()
////                        }
////                    }
//                    self.totalPrintCount -= 1
//                    self.firstLabelMaxPrintCount = 6
//                    self.secondLabelMaxPrintCount = 2
//                    DispatchQueue.main.async {
//                        //let def = UserDefaults()
//                        if let defValue = defaults.value(forKey: kJoin) as? String{
//                            self.isInitialsFoundForBrownPrinter(joinString: defValue)
//                        }
//                    }
//                    if totalPrintCount == 0{
//                        DispatchQueue.main.async {
//                            showAlert(message: Messages.PRINT_SUCCESS, buttonClicked: { (action) in})
//                        }
//                    }
//                }
//            }
//            else if (status ?? "") == PrintStyle.HomeDraw {
//
//                self.totalPrintCount -= 1
//                if self.isPrintBarcode{
//                    LPAPI.startDraw(kPageWidth, height: kPageHeight, orientation: 0)
//                    LPAPI.setItemHorizontalAlignment(0)
//                    LPAPI.drawText(self.idLabelString, x: 12, y: 1, width: kPageWidth - 8.0, height: 15.0, fontHeight: globalfontHeight)
//
//                    LPAPI.drawQRCode(self.rowData, x: 11, y: 4, width: 18, height: 18, eccLevel: 0, autoResetWidth: true)
//
//                    //let image = LPAPI.endDraw()
//
//                    if appDelegate.isForUser {
//
//                            let image = LPAPI.endDraw()
//
////                            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
////                            imageview.backgroundColor = .lightGray
////                            imageview.image = image
////                            self.view.addSubview(imageview)
//
//                            PQAPI.print(image, width: Int(kPageWidth), height: Int(kPageHeight)) { success in
//
////                                if success{
////                                    self.checkPrintConnection = true
////                                }else{
////                                    self.checkPrintConnection = false
////                                }
//                                DispatchQueue.main.async {
//                                    showAlert(message: Messages.PRINT_SUCCESS, buttonClicked: { (action) in})
//                                }
//                            }
//
//
//                    }else{
//                        let image = LPAPI.endDraw()
//                    }
//                }else{
////                    DispatchQueue.main.async {
////                        showAlert(message: Messages.PRINT_SUCCESS, buttonClicked: { (action) in})
////                    }
//                }
//            }
        }
        else{
            DispatchQueue.main.async {
                showAlert(message: Messages.PRINT_FAIL, buttonClicked: { (action) in
                   
                        let vc: BluetoothListVC = Utility.pushToViewParam(sb: "HomeSB", currentVC: self, nextVC: String(describing: BluetoothListVC.self)) as! BluetoothListVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.printClosure = { printBool in
                            if printBool{
                                self.printLabel(printer: .brownPrinter)
                            }
                        }
                        self.present(vc, animated: true)
                    
                })
            }
        }
    }
    
    func isInitialsNotFound(printer:Printers) {
        //let def = UserDefaults()
        let alert = UIAlertController(title: kAppName, message: Messages.ENTER_INITIALS, preferredStyle: .alert)
        alert.addTextField { (FNameTextField) in
            FNameTextField.placeholder = Messages.ENTER_FNAME
            FNameTextField.autocapitalizationType = .sentences
        }
        alert.addTextField { (LNameTextField) in
            LNameTextField.placeholder = Messages.ENTER_FAMILY_NAME
            LNameTextField.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let fname = alert.textFields?[0].text
            let lname = alert.textFields?[1].text
            if fname != "" && lname != ""{
                let fName = String(fname!.first!) + "."
                let lName = String(lname!)
                let makeJoin = fName + lName
                defaults.setValue(makeJoin.uppercased(), forKey: kJoin)
                
                self.ForensicprinterSecondPartLabelData.removeAll()
                self.ForensicprinterSecondPartLabelData.append("\u{21E6} Initials / Taken by \(defaults.value(forKey: kJoin) as? String ?? "")")
                self.printLabel(printer: printer)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func recursivePrintCall(image:UIImage, printCount:Int){
        var count = printCount
        print("printCount:::\(count)")
        if(count != 0){
            PQAPI.print(image, width: Int(kPageWidth), height: Int(kPageHeight)) { success in
                
                if(success){
                    count -= 1
                    self.recursivePrintCall(image: image, printCount: count)
                }
            }
        }
    }
    
    private func recursivePrintCallForQR(imageDetail:UIImage, imageQR:UIImage, printCount:Int){
        var count = printCount
        print("printCount:::\(count)")
        if(count != 0){
            
            PQAPI.print((count % 2 == 0) ? imageDetail : imageQR, width: Int(kPageWidth), height: Int(kPageHeight)) { success in
                
                if(success){
                    count -= 1
                    self.recursivePrintCallForQR(imageDetail: imageDetail, imageQR: imageQR, printCount: count)
                }
            }
        }
    }
    
    func makeHtmlString() {
        let status = defaults.value(forKey: kPrintStyle) as? String
        if status == PrintStyle.HomeDraw {
            htmlString = homeDrawprinterData.joined(separator: "\n")
            htmlString.append("\n\(prefixTitle.drawnBy): \(defaults.value(forKey: kJoin) as? String ?? "")")
            htmlString.append("\n\(prefixTitle.currentTime)(24h):  \(currentTime)")
        }else{
            /*if firstLabelMaxPrintCount == 6 {
             var takenBy = ""
             
             if ForensicprinterFirstLabelData[ForensicprinterFirstLabelData.count-1].contains("Taken by") {
             takenBy = ForensicprinterFirstLabelData[ForensicprinterFirstLabelData.count-1]
             ForensicprinterFirstLabelData.remove(at: ForensicprinterFirstLabelData.count-1)
             self.ForensicprinterFirstLabelData.insert(takenBy, at: ForensicprinterFirstLabelData.count-2)//append(takenBy)
             }
             }*/
            
            if(status == PrintStyle.MC){
                if(ForensicprinterFirstLabelData.count > 0){
                    ForensicprinterFirstLabelData.removeLast()
                }
                htmlString = ForensicprinterFirstLabelData.joined(separator: "\n")
            }else{
                htmlString = ForensicprinterFirstLabelData.joined(separator: "\n")
            }
            
//            if firstLabelMaxPrintCount == 6 {
                var takenBy = ""
                if ForensicprinterSecondPartLabelData.contains("Taken by") {
                    takenBy = ForensicprinterSecondPartLabelData
                    ForensicprinterSecondPartLabelData.removeAll()
//                    if status == PrintStyle.Forensic {
//                        htmlStringSecondPart = takenBy
//                    } else
                    if status == PrintStyle.ALMSC || status == PrintStyle.Forensic  || status == PrintStyle.MC{
                        htmlStringSecondPart = ForensicprinterThirdPartLabelData.joined(separator: "\n")
                    }
                }
                if status == PrintStyle.Forensic {
                    htmlStringThirdPart = ForensicprinterThirdPartLabelData.joined(separator: "\n")
                } else if status == PrintStyle.ALMSC {
                    htmlStringThirdPart = "\(Messages.CollectedBy): \(UserDefaults.standard.value(forKey: kJoin) as? String ?? "")"

                }
//            }
            //htmlStringSecondPart = ForensicprinterSecondPartLabelData//.joined(separator: "\n")
            //htmlStringThirdPart = ForensicprinterThirdPartLabelData.joined(separator: "\n")
            
            //htmlStringForSecondLabel = ForensicprinterSecondLabelData.joined(separator: "\n")
        }
    }
}

//MARK:- EXTENSION TABLEVIEW

extension CustomerInfoVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrScannedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTVCell", for: indexPath) as? LabelTVCell else{
            return UITableViewCell()
        }
        
        if filteredData[ScannedDataPrefix.familyName] != nil{
            if indexPath.row == 0 || indexPath.row == 1{
                cell.btnEditAction.isHidden = false
            }else{
                cell.btnEditAction.isHidden = true
            }
        }else{
            cell.btnEditAction.isHidden = true
        }
        
        cell.lblName?.text = arrScannedData[indexPath.row]
        cell.lblName?.numberOfLines = 0
        
        cell.btnEditAction.tag = indexPath.row
        cell.btnEditAction.addTarget(self, action: #selector(editLastNameInCell(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    @objc func editLastNameInCell(sender: UIButton){
        
        if sender.tag == 0 || sender.tag == 1{
            
//            let indexPath = IndexPath(row: sender.tag, section: 0)
//            guard let cell = tblShowCustomerScannedDetail.cellForRow(at: indexPath) as? LabelTVCell else { return }
            
            let alert = UIAlertController(title: kAppName, message: Messages.ADD_SCAN_DETAIL, preferredStyle: .alert)
            alert.addTextField { (FamilyNameTextField) in
                FamilyNameTextField.text = sender.tag == 0 ? self.filteredData[ScannedDataPrefix.familyName] : self.filteredData[ScannedDataPrefix.firstName]
                FamilyNameTextField.placeholder = sender.tag == 0 ? Messages.ENTER_FAMILY_NAME : Messages.ENTER_FIRST_NAME
                FamilyNameTextField.autocapitalizationType = .sentences
            }
            
            alert.addAction(UIAlertAction(title: ButtonTitle.UPDATE, style: .default, handler: {[weak self] (action) in
                
                guard let self = self else {return}
                
                let name = alert.textFields?[0].text
                self.filteredData[sender.tag == 0 ? ScannedDataPrefix.familyName : ScannedDataPrefix.firstName] = name
                self.arrScannedData.removeAll()
                
                switch self.segOutlet.selectedSegmentIndex {
                case 0:
                    self.idLabelString.removeAll()
                    self.homeDrawprinterData.removeAll()
                    self.setUpScannedData()
                case 1,2,4:
                    self.idLabelString.removeAll()
                    self.ForensicprinterFirstLabelData.removeAll()
                    self.ForensicprinterSecondPartLabelData.removeAll()
                    self.ForensicprinterThirdPartLabelData.removeAll()
                    self.ForensicprinterSecondLabelData.removeAll()
                    self.ForensicDataSetUp()
                case 3:
                    self.idLabelString.removeAll()
                    self.homeDrawprinterData.removeAll()
                    self.setUpC19Data()
                default:
                    break
                }
                
                self.tblShowCustomerScannedDetail.reloadData()
            }))
            alert.addAction(UIAlertAction(title: ButtonTitle.CANCEL, style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CustomerInfoVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        txtSelectPrinter.text = selectedPrinter.rawValue
    }
}
