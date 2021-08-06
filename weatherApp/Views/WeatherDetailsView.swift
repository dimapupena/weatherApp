//
//  WeatherDetailsView.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 28.06.2021.
//

import Foundation
import UIKit

class WeatherDetailsView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .brown
        self.alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
