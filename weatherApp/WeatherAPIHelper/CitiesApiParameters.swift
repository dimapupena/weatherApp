//
//  CitiesApiParameters.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 03.09.2021.
//

import Foundation
import Alamofire

class CitiesApiParameters: ApiParameters {
    
    static var headers: HTTPHeaders = [
        "x-rapidapi-key": "42ba417793mshf26515243e5ac15p15ebc3jsne8dc5a9d8ab5",
        "x-rapidapi-host": "countries-cities.p.rapidapi.com"
    ]
    
    enum Endpoints {
        static let base = "https://countries-cities.p.rapidapi.com"
        
        case citiesNearby
        
        var stringValue: String {
            switch self {
            case .citiesNearby:
                return Endpoints.base + "/location/city/nearby"
            }
        }
        
        var url: URL? {
            return URL(string: stringValue) ?? nil
        }
    }
}
