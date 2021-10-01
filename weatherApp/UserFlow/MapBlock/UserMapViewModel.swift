//
//  UserMapViewModel.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 01.10.2021.
//

import Foundation
import CoreLocation

class UserMapViewModel {
    
    private var startLocation: CLLocation?
    
    init(startLocation: CLLocation?) {
        self.startLocation = startLocation
    }
    
    func findCurrentLocation() {
        print("action")
    }
    
}
