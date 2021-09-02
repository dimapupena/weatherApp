//
//  CoreLocation.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 02.09.2021.
//

import Foundation
import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { locations, error in
            completion(locations?.first?.locality, locations?.first?.country, error)
        }
    }
}
