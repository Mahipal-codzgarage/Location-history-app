//
//  MarkerModel.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import Foundation

class MarkerModel {
    
    var address : String!
    var latitude : Double!
    var longitude : Double!
    var note : String!
    var place_id : String!
    var date: String!
    
    init() {
        // init
    }
    
    //MARK: - Marker set value
    // Get data from Dictionary
    func setMarkerDataDict(fromDictionary dictionary: [String:Any]){
        
        self.address = dictionary["address"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0
        self.longitude = dictionary["longitude"] as? Double ?? 0
        self.note = dictionary["note"] as? String ?? ""
        self.place_id = dictionary["place_id"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
    }
    
    // Get data from values
    func setMarkerData(address getAddress:String,place placeId: String, latitude getLatitude: Double, longitude getLongitude: Double, note getNote: String){
        
        self.address = getAddress
        self.latitude = getLatitude
        self.longitude = getLongitude
        self.note = getNote
        self.place_id = placeId
    }
}
