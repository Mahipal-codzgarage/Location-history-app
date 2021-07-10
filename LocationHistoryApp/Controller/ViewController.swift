//
//  ViewController.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 08/07/21.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController {
    
    var resultArray = [Result]()
    var markerArray = [MarkerModel]()
    
    var lastLat: Double = 0
    var lastLaong: Double = 0
    
    var currentLat: Double = 0
    var currentLaong: Double = 0
    
    var viewMap:GMSMapView?
    var timer: Timer?
    var isNearestLocAdded = false
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markerArray.removeAll()
        LocationHelper.shared.locationManagerDelegate = self
        
        // Set google map
        setupMapView()
        
        // set timer interval - indentify for location changes continuously
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch location from database
        fetchLocationFromDB()
    }
    
    //MARK: - fetch locations from database
    func fetchLocationFromDB() {
        
        viewMap?.clear()
        markerArray.removeAll()
        
        let getAddresses = DatabaseManager.shared.fetchLocationRecord(query: "SELECT *from History")
        for data in getAddresses {
            if let getData = data as? [String: Any] {
                let markerObj = MarkerModel()
                markerObj.setMarkerDataDict(fromDictionary: getData)
                self.displayMarker(markerModel: markerObj)
            }
        }
    }
    
    //MARK: - Load google map
    func setupMapView() {
        
        viewMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: GMSCameraPosition.camera(withLatitude: 20.5937, longitude: 78.9629, zoom: 6))
        viewMap?.center = self.view.center
        viewMap?.delegate = self
        self.view.addSubview(viewMap!)
    }
    
    //MARK: - Display marker on google map
    func displayMarker(markerModel getMarkerObj: MarkerModel) {
        
        markerArray.append(getMarkerObj)
        
        DispatchQueue.main.async {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: getMarkerObj.latitude, longitude: getMarkerObj.longitude)
            marker.title = getMarkerObj.note
            marker.snippet = getMarkerObj.address
            marker.map = self.viewMap
        }
    }
    
    //MARK: - Update
    @objc func update() {
        
        let userLastPlace = CLLocation(latitude: lastLat, longitude: lastLaong)
        let userCurrentPlace = CLLocation(latitude: currentLat, longitude: currentLaong)
        
        let distanceInMeters = userCurrentPlace.distance(from: userLastPlace)
        
        // verify last location and current location - distance within 100 miters,
        // if distance within 100 miters fetch current place.
        if distanceInMeters < 100 {
            if !isNearestLocAdded {
                isNearestLocAdded = true
                googleReverseGeoLocation(pdblLatitude: currentLat, withLongitude: currentLaong)
            }
        } else {
            isNearestLocAdded = false
        }
        
        lastLat = currentLat
        lastLaong = currentLaong
    }
}

//MARK: - LocationManager Delegate
extension ViewController: LocationManagerDelegate {
    
    // fetch current location
    func getLocation(location: CLLocation) {
        let currentLocation = location.coordinate
        
        currentLat = currentLocation.latitude
        currentLaong = currentLocation.longitude
        
        if lastLat == 0 && lastLaong == 0 {
            lastLat = currentLocation.latitude
            lastLaong = currentLocation.longitude
            
            googleReverseGeoLocation(pdblLatitude: currentLat, withLongitude: currentLaong)
        }
    }
    
    // google reverse geo location - identify current place from latitude and longitude
    func googleReverseGeoLocation(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        
        self.resultArray.removeAll()
        
        let setURL: URL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&key=AIzaSyDf1pq-8PW6SdpPi_ryesFJbMEGZ8GkVQU")!
        
        APIManager.shared.getRequestURL(getURL: setURL) { (isSuccess, dataDict) in
            
            if isSuccess {
                let rootData = RootClass(fromDictionary: dataDict ?? [String: Any]())
                if rootData.results.count > 0 {
                    self.resultArray = rootData.results
                    
                    let currentAddrsss = self.resultArray[0]
                    var addressText = ""
                    
                    if currentAddrsss.addressComponents.count > 0 {
                        
                        for finalAddress in currentAddrsss.addressComponents {
                            addressText += "\(finalAddress.longName ?? ""), "
                        }
                        let placeLat = currentAddrsss.geometry.location.lat ?? 0
                        let placeLong = currentAddrsss.geometry.location.lng ?? 0
                        
                        let getDate = Date().getCurrentDateTime().0
                        let getTime = Date().getCurrentDateTime().1
                      
                        // filter array count is not 0 - location already stored in database
                        let filteredArray = self.markerArray.filter { $0.place_id == currentAddrsss.placeId }
                        
                        if filteredArray.count == 0 {
                            
                            // store location into database & show marker on google map
                            DatabaseManager.shared.insertLocationRecord(address: addressText, place: currentAddrsss.placeId, getLatitude: placeLat, getLongitude: placeLong, getDate: getDate, getTime: getTime, getNote: "") { (isSuccess) in
                                if isSuccess {
                                    let markerObj = MarkerModel()
                                    markerObj.setMarkerData(address: addressText, place: currentAddrsss.placeId ?? "", latitude: placeLat, longitude: placeLong, note: "")
                                    self.displayMarker(markerModel: markerObj)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - GMSMapView Delegate
extension ViewController: GMSMapViewDelegate {
    
    // Add marker pin - long press 
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        googleReverseGeoLocation(pdblLatitude: coordinate.latitude, withLongitude: coordinate.longitude)
    }
}
