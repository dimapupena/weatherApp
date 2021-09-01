//
//  LocationManager.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 01.09.2021.
//

import Foundation
import CoreLocation

protocol Locationable {
    func requestPermission()
}

protocol LocationManagerdelegate: AnyObject {
    func locationWasUpdated()
}

final class LocationManager: NSObject, Locationable {
    let manager: CLLocationManager
    weak var delegate: LocationManagerdelegate?
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        
        self.manager.delegate = self
    }
    
    func requestPermission() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get user location: \(locations.first?.coordinate)")
        delegate?.locationWasUpdated()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location ERROR: \(error.localizedDescription)")
    }
}
