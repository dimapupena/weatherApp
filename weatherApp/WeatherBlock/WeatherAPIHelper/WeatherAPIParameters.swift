//
//  WeatherAPIParameters.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 23.06.2021.
//

import Foundation
import Alamofire

class WeatherAPIParameters: ApiParameters {
    static var headers: HTTPHeaders = [
        "x-rapidapi-key": "42ba417793mshf26515243e5ac15p15ebc3jsne8dc5a9d8ab5",
        "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
    ]
    
    enum Endpoints {
        static let base = "https://weatherapi-com.p.rapidapi.com"
        
        case currentWeather
        case forecast
        
        var stringValue: String {
            switch self {
            case .currentWeather:
                return Endpoints.base + "/current.json"
            case .forecast:
                return Endpoints.base + "/forecast.json"
            }
        }
        
        var url: URL? {
            return URL(string: stringValue) ?? nil
        }
    }
}
