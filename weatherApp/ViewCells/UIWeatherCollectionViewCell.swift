//
//  UIWeatherCollectionViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 25.06.2021.
//

import Foundation
import UIKit

class UIWeatherCollectionViewCell: UICollectionViewCell {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .red
    }
    
    func updateweatherData(city: String, temperature: String, condition: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .red
        
        setupCityLabel()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
        self.cityLabel.text = city
        self.temperatureLabel.text = temperature
        self.weatherConditionLabel.text = condition
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCityLabel() {
        self.contentView.addSubview(cityLabel)
        
        cityLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cityLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupTemperatureLabel() {
        self.contentView.addSubview(temperatureLabel)
        
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        temperatureLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupWeatherConditionLabel() {
        self.contentView.addSubview(weatherConditionLabel)
        
        weatherConditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor).isActive = true
        weatherConditionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        weatherConditionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weatherConditionLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
