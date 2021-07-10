//
//  ApiManager.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import Foundation

// MARK: - API Manager Class
class APIManager: NSObject {
    
    typealias CompletionHandler = (_ success:Bool,_ dataDict: [String: Any]?) -> Void
    
    struct SharedInstance {
        static let instance = APIManager()
    }
    
    class var shared: APIManager {
        return SharedInstance.instance
    }
    
    // Get request
    func getRequestURL(getURL: URL, completionHandler: @escaping CompletionHandler) {
        
        if Shared.shared.isReachable {
            DispatchQueue.global(qos: .utility).async {
                URLSession.shared.dataTask(with: getURL) { data, response, error in
                    do {
                        if let getData = data {
                            let getResponse = try JSONSerialization.jsonObject(with: getData, options: .allowFragments)
                            if let getJsonData: [String: Any] = getResponse as? [String: Any] {
                                completionHandler(true, getJsonData)
                            }
                        }
                    } catch {
                        print("error - api call \(error.localizedDescription)")
                        completionHandler(false, nil)
                    }
                }.resume()
            }
        }
    }
}
