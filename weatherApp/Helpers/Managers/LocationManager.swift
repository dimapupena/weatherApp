//
//  LocationManager.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 01.09.2021.
//

import Foundation
import CoreLocation

protocol Locationable {
    var delegate: LocationManagerDelegate? {get set}
    
    func requestPermission()
    func checkUserPermission() -> CLAuthorizationStatus
}

protocol LocationManagerDelegate: AnyObject {
    func locationWasUpdated(to location: UserLocation)
}

final class LocationManager: NSObject, Locationable {
    private let manager: CLLocationManager
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        
        self.manager.delegate = self
    }
    
    func requestPermission() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func checkUserPermission() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get user location: \(locations.first?.coordinate)")
        locations.first?.fetchCityAndCountry(completion: { [weak self] city, country, error in
            self?.delegate?.locationWasUpdated(to: UserLocation(city: city ?? ""))
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location ERROR: \(error.localizedDescription)")
    }
}
