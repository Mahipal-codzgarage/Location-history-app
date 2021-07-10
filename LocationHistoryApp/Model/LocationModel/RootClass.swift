//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct RootClass: Decodable{

	var plusCode : PlusCode!
	var results : [Result]!
	var status : String!

	init(fromDictionary dictionary: [String:Any]) {
		if let plusCodeData = dictionary["plus_code"] as? [String:Any]{
				plusCode = PlusCode(fromDictionary: plusCodeData)
			}
		results = [Result]()
		if let resultsArray = dictionary["results"] as? [[String:Any]]{
			for dic in resultsArray{
				let value = Result(fromDictionary: dic)
				results.append(value)
			}
		}
		status = dictionary["status"] as? String
	}

}
