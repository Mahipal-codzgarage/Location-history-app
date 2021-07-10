//
//	AddressComponent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct AddressComponent: Decodable{

	var longName : String!
	var shortName : String!
	var types : [String]!

	init(fromDictionary dictionary: [String:Any]){
		longName = dictionary["long_name"] as? String
		shortName = dictionary["short_name"] as? String
		types = dictionary["types"] as? [String]
	}

}
