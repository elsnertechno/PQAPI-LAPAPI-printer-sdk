
import UIKit

//MARK:- MENU NAME STRUCT

struct Menus {
    var menuName:String
}

class SideMenuVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet var tblViewSideMenu: UITableView!
    
    //MARK:- GLOBAL VARIABLES
    
    var arrMenuOptions:[Menus] = []
    
    //MARK:- VIEWCONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSideMenu()
    }
    
    //MARK:- CUSTOM FUNCTION
    
    @objc func setUpSideMenu(){
        arrMenuOptions = []
        arrMenuOptions.append(Menus(menuName: MenusNames.scanId))
        //arrMenuOptions.append(Menus(menuName: MenusNames.search))
        //arrMenuOptions.append(Menus(menuName: MenusNames.scannedList))
        arrMenuOptions.append(Menus(menuName: MenusNames.labelSetting))
        arrMenuOptions.append(Menus(menuName: MenusNames.printerSetting))
        tblViewSideMenu.reloadData()
    }
}

//MARK:- EXTENSION TABLEVIEW

extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTblCell") as! SideMenuTblCell
        cell.menuOption.text = arrMenuOptions[indexPath.row].menuName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch arrMenuOptions[indexPath.row].menuName {
        case MenusNames.scanId:
            let centerVC:ScanIDVC = UIStoryboard(storyboard: .HomeSB).instantiateViewController()
            centerVC.title = MenusNames.scanId
            Utility.shared.setCenterPanel(centerViewController: centerVC,fromVc: self)
            break
        case MenusNames.search:
            let centerVC:SearchVC = UIStoryboard(storyboard: .SearchSB).instantiateViewController()
            centerVC.title = MenusNames.search
            Utility.shared.setCenterPanel(centerViewController: centerVC,fromVc: self)
            break
        case MenusNames.scannedList:
            let centerVC:ScannedListVC = UIStoryboard(storyboard: .ScannedListSB).instantiateViewController()
            centerVC.title = MenusNames.scannedList
            Utility.shared.setCenterPanel(centerViewController: centerVC,fromVc: self)
            break
        case MenusNames.labelSetting:
            let centerVC:LabelSettingVC = UIStoryboard(storyboard: .LabelSettingSB).instantiateViewController()
            centerVC.title = MenusNames.labelSetting
            Utility.shared.setCenterPanel(centerViewController: centerVC,fromVc: self)
            break
        case MenusNames.printerSetting:
            let centerVC:PrinterSettingVC = UIStoryboard(storyboard: .PrinterSettingSB).instantiateViewController()
            centerVC.title = MenusNames.printerSetting
            Utility.shared.setCenterPanel(centerViewController: centerVC,fromVc: self)
            break
        default:
            break
        }
    }
}
