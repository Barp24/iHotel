//
//  HotelName.swift
//  iHotel
//
//  Created by admin on 08/06/2022.
//

import Foundation

struct HotelName: Decodable {
    let id: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
    }
}

struct HotelNames: Decodable {
    let count: Int
    let all: [HotelName]
    
    enum CodingKeys: String, CodingKey {
        case count
        case all = "results"
    }
}


