//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import UIKit
import SnapKit
import Foundation

// viewController
// protocol
// ref to presenter

enum CollectionCellSize: Int {
    case collectionHeight = 200
    case collectionWidth = 250
}

enum CollectionViewType {
    case oftenLocation
    case weatherInfo
}

protocol AnyView {
    var presenter: AnyPresenter? { get set }
}

protocol AnyWeatherView: AnyView {
    func updateWeahter(with weather: Weather?)
    func updateForecastWeahter(with forecast: ForecastWeather?)
    func locationWasUpdated(to location: UserLocation)
    func updateWeahterWithError(with error: Error?)
    func updateNearbyCities(cities: [String])
}

class WeatherViewController: UIViewController, AnyWeatherView {
    var presenter: AnyPresenter?
    
    let dailyWeatherCollectionViewCellId = "weatherCell"
    let locationsCollectionViewCellId = "locationCell"

    var forecast: ForecastWeather?
    var nearbyCities: String? = ""
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 15
        textField.placeholder = "Enter city name"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.borderColor = .init(red: 125, green: 22, blue: 15, alpha: 1.0)
        textField.layer.borderWidth = 2
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Find", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var locationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UILocationCollectionViewCell.self, forCellWithReuseIdentifier: locationsCollectionViewCellId)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var dailyWeatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UIWeatherCollectionViewCell.self, forCellWithReuseIdentifier: dailyWeatherCollectionViewCellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private let weatherDetailsView: WeatherDetailsView = WeatherDetailsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 191, green: 181, blue: 180)
        
        setupTextField()
        setupSearchButton()
        setupLocationsCollectionView()
        setupDailyWeatherCollectionView()
        setupWeatherDetailsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.handleLocationPermission()
    }
    
    private func setupTextField() {
        self.view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupSearchButton() {
        self.view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(searchTextField)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(searchTextField.snp.trailing).offset(20)
            make.width.equalTo(50)
        }
    }
    
    private func setupLocationsCollectionView() {
        self.view.addSubview(locationsCollectionView)
        
        locationsCollectionView.dataSource = self
        locationsCollectionView.delegate = self
        
        locationsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func setupDailyWeatherCollectionView() {
        self.view.addSubview(dailyWeatherCollectionView)
        
        dailyWeatherCollectionView.dataSource = self
        dailyWeatherCollectionView.delegate = self
        
        dailyWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(locationsCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat(CollectionCellSize.collectionHeight.rawValue))
        }
    }
    
    private func setupWeatherDetailsView() {
        self.view.addSubview(weatherDetailsView)
        weatherDetailsView.snp.makeConstraints { make in
            make.top.equalTo(dailyWeatherCollectionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func updateWeahter(with weather: Weather?) {
        guard let weather = weather else { return }
        print("update view with weather")

        DispatchQueue.main.async { [weak self] in
            self?.weatherDetailsView.updateWeatherData(weather)
        }
    }
    
    func updateForecastWeahter(with forecast: ForecastWeather?) {
        guard let forecast = forecast else { return }
        self.forecast = forecast
        print("update view with forecast weather")
        
        DispatchQueue.main.async { [weak self] in
            self?.dailyWeatherCollectionView.reloadData()
        }
    }

    func updateWeahterWithError(with error: Error?) {
        print("update view with error")
    }
    
    func locationWasUpdated(to location: UserLocation) {
        guard let presenter = presenter as? AnyWeatherPresenter else { return }
        print("NEW location: \(location.city)")
        self.changeWeather(for: location)
    }
    
    func updateNearbyCities(cities: [String]) {
        self.locationsCollectionView.reloadData()
    }
    
    private func notifyAboutDeniedLocationPerm() {
        print("don't have permission for location")
    }
    
    private func getCollectionType(_ view: UICollectionView) -> CollectionViewType {
        if view == locationsCollectionView {
            return .oftenLocation
        } else {
            return .weatherInfo
        }
    }
    
    @objc private func searchButtonClicked() {
        print("fetching data")
        guard let presenter = presenter as? AnyWeatherPresenter else { return }
        let location = UserLocation(city: searchTextField.text!)
        presenter.fetchWeather(location)
        presenter.exploreForecast(location, days: 10)
    }
    
    private func changeWeather(for location: UserLocation?) {
        guard let location = location, let presenter = presenter as? AnyWeatherPresenter else { return }
        presenter.fetchWeather(location)
        presenter.exploreForecast(location, days: 10)
    }
    
    private func handleLocationPermission() {
        guard let presenter = presenter as? WeatherPresenter else { return }
        let status = presenter.locationable?.checkUserPermission()
        switch status {
        case .authorizedAlways:
            presenter.locationable?.updateUserLocation()
        case .authorizedWhenInUse:
            presenter.locationable?.updateUserLocation()
        case .denied:
            notifyAboutDeniedLocationPerm()
        case .notDetermined:
            presenter.locationable?.requestPermission()
        default:
            presenter.locationable?.requestPermission()

        }
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch getCollectionType(collectionView) {
        case .oftenLocation:
            return 5
        case .weatherInfo:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch getCollectionType(collectionView) {
        case .oftenLocation:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: locationsCollectionViewCellId, for: indexPath) as! UILocationCollectionViewCell
            cell.updateData(location: "London")
            return cell
        case .weatherInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dailyWeatherCollectionViewCellId, for: indexPath) as! UIWeatherCollectionViewCell
            cell.updateWeatherData(forecast?.forecast.forecastday[indexPath.row], location: forecast?.location)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch getCollectionType(collectionView) {
        case .oftenLocation:
            return CGSize(width: 200, height: 50)
        case .weatherInfo:
            return CGSize(width: CollectionCellSize.collectionWidth.rawValue, height: CollectionCellSize.collectionHeight.rawValue)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch getCollectionType(collectionView) {
        case .oftenLocation:
            let cell = collectionView.cellForItem(at: indexPath) as? UILocationCollectionViewCell
            self.changeWeather(for: cell?.getLocation())
            print("oftenLocation action", indexPath.row)
        case .weatherInfo:
            print("weatherInfo action", indexPath.row)
        }
    }
    
}
