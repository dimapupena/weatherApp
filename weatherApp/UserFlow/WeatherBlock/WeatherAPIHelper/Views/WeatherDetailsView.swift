//
//  WeatherDetailsView.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 28.06.2021.
//

import Foundation
import UIKit

class WeatherDetailsView: UIScrollView {
    
    private let cityLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let weatherConditionLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .brown
        self.alpha = 0.5
        setupCityLabel()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWeatherData(_ weather: Weather) {
        self.cityLabel.text = weather.location.locationName
        self.temperatureLabel.text = NSDecimalNumber(decimal: weather.currentWeather.temp_c).stringValue
        self.weatherConditionLabel.text = weather.currentWeather.condition.weatherTitle
    }
    
    private func setupCityLabel() {
        self.addSubview(cityLabel)
        cityLabel.textColor = .white
        
        cityLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.textColor = .white
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(cityLabel)
            make.leading.equalTo(cityLabel.snp.trailing).offset(20)
        }
    }
    
    private func setupWeatherConditionLabel() {
        self.addSubview(weatherConditionLabel)
        weatherConditionLabel.textColor = .white
        
        weatherConditionLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
}
