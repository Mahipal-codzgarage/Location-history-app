//
//	Northeast.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Northeast: Decodable{

	var lat : Double!
	var lng : Double!

	init(fromDictionary dictionary: [String:Any]){
		lat = dictionary["lat"] as? Double
		lng = dictionary["lng"] as? Double
	}

}
