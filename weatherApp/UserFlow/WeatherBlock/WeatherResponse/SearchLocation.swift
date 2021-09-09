//
//  SearchWeather.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 07.09.2021.
//

import Foundation

struct SearchLocation: Decodable {
    let lat: Decimal
    let lon: Decimal
    let name: String
    let region: String
    let country: String
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}
