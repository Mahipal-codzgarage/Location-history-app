//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Result: Decodable{

	var addressComponents : [AddressComponent]!
	var formattedAddress : String!
	var geometry : Geometry!
	var placeId : String!
	var plusCode : PlusCode!
	var types : [String]!

	init(fromDictionary dictionary: [String:Any]){
		addressComponents = [AddressComponent]()
		if let addressComponentsArray = dictionary["address_components"] as? [[String:Any]]{
			for dic in addressComponentsArray{
				let value = AddressComponent(fromDictionary: dic)
				addressComponents.append(value)
			}
		}
		formattedAddress = dictionary["formatted_address"] as? String
		if let geometryData = dictionary["geometry"] as? [String:Any]{
				geometry = Geometry(fromDictionary: geometryData)
			}
		placeId = dictionary["place_id"] as? String
		if let plusCodeData = dictionary["plus_code"] as? [String:Any]{
				plusCode = PlusCode(fromDictionary: plusCodeData)
			}
		types = dictionary["types"] as? [String]
	}

}
