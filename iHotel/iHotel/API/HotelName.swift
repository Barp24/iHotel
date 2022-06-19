//
//  HotelName.swift
//  iHotel
//
//  Created by admin on 08/06/2022.
//

import Foundation

struct HotelName: Decodable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct HotelNames: Decodable {
    let all: [HotelName]
    
    enum CodingKeys: String, CodingKey {
        case all = "results"
    }
}


