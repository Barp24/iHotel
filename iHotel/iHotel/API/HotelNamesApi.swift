//
//  HotelNamesApi.swift
//  iHotel
//
//  Created by admin on 08/06/2022.
//

import Foundation
import Alamofire

class HotelNamesApi{
    
    static func getHotelNames(onComplete:@escaping (HotelNames?)->Void){
        let hotelNamesApiUrl = "https://my-json-server.typicode.com/Barp24/iHotel/hotels"
        AF.request(hotelNamesApiUrl).responseDecodable(of:HotelNames.self){ response in
            switch response.result{
            case .success(let data):
                print(data);
                print ("success")
                onComplete(data)
            case .failure(let error):
                print("error : \(error)")
                onComplete(nil)
            }
        }
    }
}
