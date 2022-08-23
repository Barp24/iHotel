//
//  CitiesApi.swift
//  iHotel
//
//  Created by admin on 08/06/2022.
//

import Foundation
import Alamofire

class CitiesApi{
    
    // Fetch cities
    static func getCities(onComplete:@escaping (Cities?)->Void){
        let apiUrl = "https://my-json-server.typicode.com/Barp24/iHotel/cities"
        AF.request(apiUrl).responseDecodable(of:Cities.self){ response in
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
