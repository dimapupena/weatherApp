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
    
    func updateWeatherData(_ forecast: ForecastDay?) {
        weatherReviewView.updateWeatherData(forecast: forecast)
    }
}

class WeatherReviewView: UIView {
    
    private let dayOfWeekLabel: UILabel = UILabel()
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
        self.backgroundColor = UIColor(red: 125, green: 181, blue: 172)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = CGColor(red: 27/255, green: 80/255, blue: 194/255, alpha: 1.0)
        
        setupCityLabel()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
    }
    
    fileprivate func updateWeatherData(forecast: ForecastDay?) {
        guard let forecast = forecast else { return }
        self.dayOfWeekLabel.text = forecast.date
        self.temperatureLabel.text = "\(forecast.day.avgtemp_c)"
        self.weatherConditionLabel.text = forecast.day.condition.weatherTitle
    }
    
    private func setupCityLabel() {
        self.addSubview(dayOfWeekLabel)
        dayOfWeekLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setupTemperatureLabel() {
        self.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeekLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func setupWeatherConditionLabel() {
        self.addSubview(weatherConditionLabel)
        weatherConditionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
