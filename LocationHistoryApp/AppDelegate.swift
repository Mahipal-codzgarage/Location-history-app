//
//  AppDelegate.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 08/07/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.applicationIconBadgeNumber = 0

        //Confirm Delegete and request for permission
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        // Google Map Key
        GMSServices.provideAPIKey("AIzaSyCkyKxxDoTz4MLzM_3hraiDxPwTrZqV13s")
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        // Check internet connectivity
        if Shared.shared.isReachable {
            print("internet reachable")
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        LocationHelper.shared.startUpdatingLocation()
    }
    
    //MARK: - Handle Notification Center Delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        completionHandler()
    }
}

