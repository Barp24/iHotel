//
//  HotelNamesApi.swift
//  iHotel
//
//  Created by admin on 08/06/2022.
//

import Foundation
import Alamofire

class HotelNamesApi{
    
//    static func getFilms(onComplete:@escaping (HotelNames?)->Void){
//        AF.request("https://swapi.dev/api/films").responseDecodable(of:HotelNames.self){ response in
//            switch response.result{
//            case .success(let data):
//                print ("success")
//                onComplete(data)
//            case .failure(let error):
//                print("error : \(error)")
//                onComplete(nil)
//            }
//        }
//    }
    
    static func getHotelNames(onComplete:@escaping ([HotelName])->Void){
        let hotelNamesApiUrl = "adada"
        var hotelNames = [HotelName]()
        let dispatchGroup = DispatchGroup()
        for index in 1...3 {
            dispatchGroup.enter()
            AF.request(hotelNamesApiUrl + String(index)).responseDecodable(of:HotelName.self){ response in
                switch response.result{
                case .success(let hotel):
                    hotelNames.append(hotel)
                case .failure(let error):
                    print("error : \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            onComplete(hotelNames)
        }
    }
}
