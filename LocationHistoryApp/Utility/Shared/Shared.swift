//
//  Shared.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import Foundation
import Reachability

//MARK: - Alert Mesaages
enum AlertType: String {
    case networkUnavailable = "Please check your internet connection and try again"
}

// MARK: - Shared Class
class Shared: NSObject {
    
    var reachability: Reachability?
    var isReachable = false
    
    struct SharedInstance {
        static let instance = Shared()
    }
    
    class var shared: Shared {
        return SharedInstance.instance
    }
    
    override init() {
        super.init()
        
        // Internet rechability
        do {
            reachability = try Reachability.init()
            try reachability!.startNotifier()
        } catch {
            print("error in reachability")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        
    }
    
    // Notify when update internet status
    @objc func reachabilityChanged(_ note: Notification) {
        
        guard let reachability = note.object as? Reachability else {
            return
        }
        
        if reachability.connection == .unavailable {
            print("internet Not reachable")
            isReachable = false
        } else {
            print("internet reachable")
            isReachable = true
        }
    }
    
    // Display alert
    func showAlert(_ setTitle: String, Description setMessage: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: setTitle, message: setMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    // Push/Pop view controller
    func pushviewController(_ destinationVC: UIViewController, inNavigationViewController navigationController: UINavigationController, animated: Bool) {
        
        var VCFound: Bool = false
        var indexofVC: NSInteger = 0
        
        for viewObj in navigationController.viewControllers {
            if viewObj .nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        
        DispatchQueue.main.async {
            
            if VCFound == true {
                for viewObj in navigationController.viewControllers where viewObj.nibName == (destinationVC.nibName) {
                    navigationController.popToViewController(viewObj, animated: animated)
                    break
                }
            } else {
                navigationController.pushViewController(destinationVC, animated: animated)
            }
        }
    }
}
