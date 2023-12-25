
import UIKit
import Foundation
import SystemConfiguration
import Alamofire

let apiManager : NetworkLayerApiManager = NetworkLayerApiManager.sharedIntance

// MARK: - typealias
// api success
typealias resultBlock = (_ response: [String:AnyHashable]?, _ error: [String:AnyHashable]?) -> Void
// api progrss indocator
typealias apiProgress = (_ response: [String:AnyObject]?) -> Void // when you want to download or upload using Alamofire..

class NetworkLayerApiManager: NSObject {
    
    // MARK: - Shared instance
    static let sharedIntance = NetworkLayerApiManager()
    
    func callJsonRequest(strURL:String, httpMethod: HTTPMethod, params:[String: AnyHashable]?, success completion :@escaping resultBlock){
        
        Alamofire.request(strURL, method:httpMethod, parameters:params, encoding:URLEncoding(destination: .methodDependent), headers: SessionManager.defaultHTTPHeaders).responseData { (response) in
            if let data = response.result.value {
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    if let jsonDic = jsonResponse as? [String:AnyHashable]{
                        completion(jsonDic, nil)
                    }else{
                        let jsonArray = jsonResponse as? [AnyObject]
                        completion(jsonArray?.first as? [String : AnyHashable], nil)
                    }
                }catch {
                    let error = [kSuccess : false,kMessage : kSomethingWentWrong] as [String : AnyHashable]
                    completion(error,nil)
                }
            }else{
                let error = [kSuccess : false,kMessage : kSomethingWentWrong] as [String : AnyHashable]
                completion(error,nil)
            }
        }
    }
    
    func uploadImageToServer(strURL:String, postdatadictionary: [AnyHashable: Any], httpMethod : HTTPMethod, completion: @escaping resultBlock) {
        
        if !Reachability.isConnectedToNetwork(){
            return
        }
        
        let url = URL(string: strURL)
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in postdatadictionary {
                if value is Data{
                    multipartFormData.append(value as! Data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                }else{
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key as! String)
                }
            }
        }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    if let jsonDic = response.result.value as? [String:AnyHashable]{
                        completion(jsonDic, nil)
                    }else{
                        let jsonArray = response.result.value as? [AnyObject]
                        completion(jsonArray?.first as? [String : AnyHashable], nil)
                    }
                }
            case .failure(let encodingError):
                let error = [kSuccess : false,kMessage : kSomethingWentWrong] as [String : AnyHashable]
                completion(error,nil)
            }
        })
    }
}
