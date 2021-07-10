//
//  LocationManager.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 08/07/21.
//

import UIKit
import CoreLocation

struct UserConstants {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let lastKnownLatitude = "lastKnownLatitude"
    static let lastKnownLongitude = "lastKnownLongitude"
}

@objc protocol LocationManagerDelegate {
    @objc optional func getLocation(location: CLLocation)
}

// MARK: - Location Helper class
class LocationHelper: NSObject {
    
    weak var locationManagerDelegate: LocationManagerDelegate?
    var isLocationfetched: Bool = false
    var lastKnownLocation: CLLocation? {
        get {
            let latitude = UserDefaults.standard.double(forKey: UserConstants.lastKnownLatitude)
            let longitude = UserDefaults.standard.double(forKey: UserConstants.lastKnownLongitude)
            
            if latitude.isZero || longitude.isZero {
                return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            UserDefaults.standard.set(newValue?.coordinate.latitude ?? 0, forKey: UserConstants.lastKnownLatitude)
            UserDefaults.standard.set(newValue?.coordinate.longitude ?? 0, forKey: UserConstants.lastKnownLongitude)
            UserDefaults.standard.synchronize()
        }
    }
    
    struct SharedInstance {
        static let instance = LocationHelper()
    }
    
    class var shared: LocationHelper {
        return SharedInstance.instance
    }
    
    enum Request {
        case requestWhenInUseAuthorization
        case requestAlwaysAuthorization
    }
    
    var clLocationManager = CLLocationManager()
    
    func setAccuracy(clLocationAccuracy: CLLocationAccuracy) {
        clLocationManager.desiredAccuracy = clLocationAccuracy
    }
    
    var isLocationEnable: Bool = false {
        didSet {
            if !isLocationEnable {
                lastKnownLocation = nil
            }
        }
    }
    
    // start updadting location
    func startUpdatingLocation() {
        
        isLocationfetched = false
       
        if #available(iOS 14.0, *) {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .restricted, .denied:
                showLocationAccessAlert()
                isLocationEnable = false
            case .notDetermined :
                clLocationManager.delegate = self
                clLocationManager.pausesLocationUpdatesAutomatically = false
                clLocationManager.allowsBackgroundLocationUpdates = true
                clLocationManager.requestWhenInUseAuthorization()
                clLocationManager.requestAlwaysAuthorization()
                clLocationManager.startUpdatingLocation()
                isLocationEnable = true
            case .authorizedAlways:
                clLocationManager.delegate = self
                clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                clLocationManager.startUpdatingLocation()
                isLocationEnable = true
            case .authorizedWhenInUse :
                showChangeStatusAccessAlert()
            default:
                print("Invalid AuthorizationStatus")
            }
        } else {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    clLocationManager.delegate = self
                    clLocationManager.pausesLocationUpdatesAutomatically = false
                    clLocationManager.allowsBackgroundLocationUpdates = true
                    clLocationManager.requestWhenInUseAuthorization()
                    clLocationManager.requestAlwaysAuthorization()
                    clLocationManager.startUpdatingLocation()
                    isLocationEnable = true
                case .restricted, .denied:
                    showLocationAccessAlert()
                    isLocationEnable = false
                case .authorizedAlways:
                    clLocationManager.delegate = self
                    clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                    clLocationManager.startUpdatingLocation()
                    isLocationEnable = true
                case .authorizedWhenInUse :
                    showChangeStatusAccessAlert()
                default:
                    print("Invalid AuthorizationStatus")
                }
            } else {
                isLocationEnable = false
            }
        }
    }
    
    // Error - Location access alert
    func showLocationAccessAlert() {
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "settings", style: .default, handler: {(cAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Error - Location Status alert
    func showChangeStatusAccessAlert() {
        let alertController = UIAlertController(title: "Location Access Required", message: "Please enable Always location access in settings.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "settings", style: .default, handler: {(cAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // stop update lcation
    func stopUpdatingLocation() {
        self.clLocationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocation Manager Delegate
extension LocationHelper : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isLocationfetched {
            isLocationfetched = true
            clLocationManager.startMonitoringSignificantLocationChanges()
        }
        let userLocation = locations[0] as CLLocation
        self.lastKnownLocation = userLocation
        if let delegate = self.locationManagerDelegate {
            delegate.getLocation!(location: userLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
            isLocationEnable = false
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            // The user accepted authorization
            self.clLocationManager.delegate = self
            self.clLocationManager.startUpdatingLocation()
            isLocationEnable = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n error description for location updation:- \(error.localizedDescription)")
    }
}
