//
//  Weather.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 23.06.2021.
//

import Foundation

struct Weather: Codable {
    let location: Location
    let currentWeather: CurrentWeather
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case currentWeather = "current"
    }
}

struct Location: Codable {
    let locationName: String
    let region: String
    let country: String
    let latitude: Decimal
    let longitude: Decimal
    let timeZone: String
    let localtimeEpoch: Int
    let localTime: String
    
    enum CodingKeys: String, CodingKey {
        case locationName = "name"
        case region = "region"
        case country = "country"
        case latitude = "lat"
        case longitude = "lon"
        case timeZone = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localTime = "localtime"
    }
}

struct CurrentWeather: Codable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Decimal
    let temp_f: Decimal
    let feelslike_c: Decimal
    let feelslike_f: Decimal
    let condition: WeatherCondition
    let wind_mph: Decimal
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Decimal
    let pressure_in: Decimal
    let precip_mm: Decimal
    let precip_in: Decimal
    let humidity: Int
    let cloud: Int
    let is_day: Int
    let uv: Decimal
    let gust_mph: Decimal
    let gust_kph: Decimal
}

struct WeatherCondition: Codable {
    let weatherTitle: String
    let icon: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case weatherTitle = "text"
        case icon
        case code
    }
}
