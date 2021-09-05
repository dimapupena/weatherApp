//
//  ForecastWeather.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 29.08.2021.
//

import Foundation

struct ForecastWeather: Decodable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let date_epoch: Int
    let day: ForecastDayWeather
    let astro: ForecastDayAstro
    let hour: [ForecastByHours]
}

struct ForecastDayWeather: Decodable {
    let maxtemp_c: Decimal
    let maxtemp_f: Decimal
    let mintemp_c: Decimal
    let mintemp_f: Decimal
    let avgtemp_c: Decimal
    let avgtemp_f: Decimal
    let maxwind_mph: Decimal
    let maxwind_kph: Decimal
    let totalprecip_mm: Decimal
    let totalprecip_in: Decimal
    let avgvis_km: Decimal
    let avgvis_miles: Decimal
    let avghumidity: Int
    let condition: WeatherCondition
    let uv: Decimal
}

struct ForecastDayAstro: Decodable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: String
}

struct ForecastByHours: Decodable {
    let time_epoch: Int
    let time: String
    let temp_c: Decimal
    let temp_f: Decimal
    let condition: WeatherCondition
    let wind_mph: Decimal
    let wind_kph: Decimal
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Decimal
    let pressure_in: Decimal
    let precip_mm: Decimal
    let precip_in: Decimal
    let humidity: Int
    let cloud: Int
    let feelslike_c: Decimal
    let feelslike_f: Decimal
    let windchill_c: Decimal
    let windchill_f: Decimal
    let heatindex_c: Decimal
    let heatindex_f: Decimal
    let dewpoint_c: Decimal
    let dewpoint_f: Decimal
    let will_it_rain: Int
    let will_it_snow: Int
    let is_day: Int
    let vis_km: Decimal
    let vis_miles: Decimal
    let chance_of_rain: Int
    let chance_of_snow: Int
    let gust_mph: Decimal
    let gust_kph: Decimal
}
