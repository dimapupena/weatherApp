//
//  WeatherRequestsHelper.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 04.09.2021.
//

import Foundation

struct ParametersFindCitiesNearby {
    let latitude: Decimal
    let longitude: Decimal
    let radius: Int?
    let minPopulation: Int?
    let maxPopulation: Int?
    
    init(latitude: Decimal, longitude: Decimal, radius: Int? = 25, minPopulation: Int = 0, maxPopulation: Int? = 100000) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.minPopulation = minPopulation
        self.maxPopulation = maxPopulation
    }
}
