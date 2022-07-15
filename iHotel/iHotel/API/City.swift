//
//  City.swift
//  iHotel
//
//  Created by admin on 08/06/2022.
//

import Foundation

struct City: Decodable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct Cities: Decodable {
    let all: [City]
    
    enum CodingKeys: String, CodingKey {
        case all = "results"
    }
}


