//
//  UIWeatherCollectionViewCell.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 25.06.2021.
//

import Foundation
import UIKit
import SnapKit

class UIWeatherCollectionViewCell: UICollectionViewCell {
    
    private let weatherReviewView: WeatherReviewView = WeatherReviewView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupWeatherReview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWeatherReview() {
        addSubview(weatherReviewView)
        weatherReviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateWeatherData(city: String, temperature: String, condition: String) {
        weatherReviewView.updateWeatherData(city: city, temperature: temperature, condition: condition)
    }
}

class WeatherReviewView: UIView {
    
    private let cityLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let weatherConditionLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .red
        self.layer.cornerRadius = 20
        
        setupCityLabel()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
    }
    
    fileprivate func updateWeatherData(city: String, temperature: String, condition: String) {
        self.cityLabel.text = city
        self.temperatureLabel.text = temperature
        self.weatherConditionLabel.text = condition
    }
    
    private func setupCityLabel() {
        self.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    private func setupTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
    
    private func setupWeatherConditionLabel() {
        self.addSubview(weatherConditionLabel)
        weatherConditionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
}
