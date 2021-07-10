//
//	Bound.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Bound: Decodable{

	var northeast : Northeast!
	var southwest : Northeast!

	init(fromDictionary dictionary: [String:Any]){
		if let northeastData = dictionary["northeast"] as? [String:Any]{
				northeast = Northeast(fromDictionary: northeastData)
			}
		if let southwestData = dictionary["southwest"] as? [String:Any]{
				southwest = Northeast(fromDictionary: southwestData)
			}
	}

}
