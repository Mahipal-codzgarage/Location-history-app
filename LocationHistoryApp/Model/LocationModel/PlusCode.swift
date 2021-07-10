//
//	PlusCode.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PlusCode: Decodable{

	var compoundCode : String!
	var globalCode : String!

	init(fromDictionary dictionary: [String:Any]){
		compoundCode = dictionary["compound_code"] as? String
		globalCode = dictionary["global_code"] as? String
	}

}
