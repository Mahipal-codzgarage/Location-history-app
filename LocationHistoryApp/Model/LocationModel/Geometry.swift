//
//	Geometry.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Geometry: Decodable{

	var bounds : Bound!
	var location : Northeast!
	var locationType : String!
	var viewport : Bound!

	init(fromDictionary dictionary: [String:Any]){
		if let boundsData = dictionary["bounds"] as? [String:Any]{
				bounds = Bound(fromDictionary: boundsData)
			}
		if let locationData = dictionary["location"] as? [String:Any]{
				location = Northeast(fromDictionary: locationData)
			}
		locationType = dictionary["location_type"] as? String
		if let viewportData = dictionary["viewport"] as? [String:Any]{
				viewport = Bound(fromDictionary: viewportData)
			}
	}

}
