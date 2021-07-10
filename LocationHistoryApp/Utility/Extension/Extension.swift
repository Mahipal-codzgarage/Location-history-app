//
//  Extension.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import UIKit
import Foundation

// MARK: - UIApplication Extension
extension UIApplication {
    
    // idenfity current/top view controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

// MARK: - Date Extension
extension Date {
    
    // date to string(Date & Time)
    func getCurrentDateTime() -> (String, String){
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let dateString = df.string(from: self)
        
        df.dateFormat = "HH:mm"
        let timeString = df.string(from: self)
        
        return(dateString,timeString)
    }
}
