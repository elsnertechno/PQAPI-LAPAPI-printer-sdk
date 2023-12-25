
import Foundation
import UIKit
import CommonCrypto
import MKProgress
import CoreLocation

//MARK:- PUBLIC FUNCTIONS

var alertWindow : UIWindow!

public func showAlert(message: String, title:String = "BaplsID", buttonTitle:String = "Ok", buttonClicked:((UIAlertAction) -> Void)?){
    let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(objAlert, animated: true, completion: nil)
    objAlert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in
        alertWindow.isHidden = true
        buttonClicked?(action)
        //alertWindow.removeFromSuperview()
    }))
    //objAlert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonClicked))
    //UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
}

public func showAlert(message: String, title:String = "BaplsID", arrActionTitles:[String], buttonClicked:((UIAlertAction) -> Void)?){
    let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for actionTitle in arrActionTitles{
        objAlert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: buttonClicked))
    }    
    UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
}

public func showProgressIn(viewcotroller:UIViewController){
    MKProgress.config.circleBorderColor = UIColor(hexString: Colors.themeColor)
    MKProgress.show()
}

public func hideProgress(){
    MKProgress.hide()
}

public func isConnectedToInternet(withAlert:Bool) -> Bool{
    let isConnected = Reachability.isConnectedToNetwork()
    if withAlert && !isConnected{
        showAlert(message: Messages.CONNECTION_ERROR, buttonClicked: nil)
    }
    return isConnected
}

public func setWindow(rootViewController:UIViewController){
    appDelegate.window = UIWindow.init(frame: UIScreen.main.bounds)
    appDelegate.window?.rootViewController = rootViewController
    appDelegate.window?.makeKeyAndVisible()
}

public func openSettings() {
    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
}

public func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

public func getDefaultCountOfSection(key: KeyForSectionName) -> Int{
    
    if UserDefaults.standard.value(forKey: key.rawValue) != nil{
        let count = UserDefaults.standard.value(forKey: key.rawValue) as? Int ?? 1
        return count
    }
    
    return 1
}

public func setDefaultCountOfSection(key: KeyForSectionName, count:Int){
    UserDefaults.standard.set(count, forKey: key.rawValue)
}

//MARK:- UTILITY CLASS

class Utility: NSObject {
    
    static let shared = Utility()
    var rootController = FAPanelController()
    
    public func setSidePanelWithHome(){
        appDelegate.window = UIWindow.init(frame: UIScreen.main.bounds)
        let leftMenuVC: SideMenuVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
        
        let centerVC : ScanIDVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
        
        centerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), landscapeImagePhone: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(self.onPressedMenuBtn))
        
        let imgLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imgLogoView.image = UIImage(named: "ic_logo")
        imgLogoView.contentMode = .scaleAspectFit
        imgLogoView.clipsToBounds = true
        imgLogoView.makeCornerRedius(radius: 10.0)
        centerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imgLogoView)
        
        let centerNavVC = UINavigationController(rootViewController: centerVC)
       
        centerNavVC.navigationBar.tintColor = UIColor(hexString: Colors.fontColor)
        centerNavVC.navigationBar.barTintColor = UIColor(hexString: Colors.themeColor)
        centerNavVC.navigationBar.isTranslucent = false
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: Colors.fontColor)
        ]
        centerNavVC.navigationBar.titleTextAttributes = attrs
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor(hexString: Colors.fontColor)]
            appearance.backgroundColor = UIColor(hexString: Colors.themeColor)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        rootController.configs.bounceOnLeftPanelOpen = false
        rootController.leftPanelPosition = .front
        _ = rootController.center(centerNavVC).left(leftMenuVC)
        appDelegate.window?.rootViewController = rootController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    class func pushToViewParam(sb: String, currentVC: UIViewController, nextVC: String) -> UIViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: sb, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: nextVC) //String(describing: nextVC.self)
        return nextViewController
    }
    
    @objc func onPressedMenuBtn(){
        rootController.left?.panel?.openLeft(animated: true)
    }
    
    public func setCenterPanel(centerViewController:UIViewController, fromVc:UIViewController){
        let centerNavVC = UINavigationController(rootViewController: centerViewController)
        centerNavVC.navigationBar.tintColor = UIColor(hexString: Colors.fontColor)
        centerNavVC.navigationBar.barTintColor = UIColor(hexString: Colors.themeColor)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: Colors.fontColor)
        ]
        centerNavVC.navigationBar.titleTextAttributes = attrs
        centerViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), landscapeImagePhone: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(onPressedMenuBtn))
        
        let imgLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imgLogoView.image = UIImage(named: "ic_logo")
        imgLogoView.contentMode = .scaleAspectFit
        imgLogoView.clipsToBounds = true
        imgLogoView.makeCornerRedius(radius: 10.0)
        centerViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imgLogoView)
        
        fromVc.panel?.configs.bounceOnCenterPanelChange = true
        fromVc.panel?.setCenterPanelVC(centerNavVC) {
        }
    }
    
    public func setLabelSettingData(labelSetting:LabelSettingModel){
        if let encoded = try? JSONEncoder().encode(labelSetting) {
            defaults.set(encoded, forKey: kLabelSetting)
        }
    }
    
    public func getLabelSettingData() -> LabelSettingModel?{
        if let data = defaults.data(forKey: kLabelSetting),
            let labelData = try? JSONDecoder().decode(LabelSettingModel.self, from: data) {
            return labelData
        }
        return nil
    }
    
    public func calculateAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
}

//MARK:- EXTENSION UIIMAGE

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

//MARK:- EXTENSION UIDATE

extension Date {
    
    func toString(dateFormat: String ) -> String {
        
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "en_US")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
}

//MARK:- EXTENSION UIVIEW

extension UIView{
    func makeCornerRedius(radius:CGFloat){
        self.layer.cornerRadius = radius
    }
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
}

//MARK:- EXTENSION UICOLOR

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

//MARK:- EXTENSION VIEWCONTROLER

extension UIViewController {
    func pushTo(viewController:UIViewController, animate:Bool = true){
        self.navigationController?.pushViewController(viewController, animated: animate)
    }
    
    func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
}

