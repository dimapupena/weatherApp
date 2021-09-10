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

enum WeatherViewState {
    case standart
    case searchingLocation
}

protocol WeatherPresenterToView {
    func updateWeahter(with weather: Weather?)
    func updateForecastWeahter(with forecast: ForecastWeather?)
    func locationWasUpdated(to location: UserLocation)
    func updateWeahterWithError(with error: Error?)
    func updateNearbyCities(cities: [String])
    func updateSearchedLocations(searchedLocations: [SearchLocation])
}

class WeatherViewController: UIViewController, WeatherPresenterToView {
    var presenter: WeatherViewToPresenter?
    
    let dailyWeatherCollectionViewCellId = "weatherCell"
    let locationsCollectionViewCellId = "locationCell"

    var forecast: ForecastWeather?
    var nearbyCities: String? = ""
    private var weatherViewState: WeatherViewState = .standart {
        didSet {
            self.updateWeatherViewState()
        }
    }
    
    private let settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settings")
        return imageView
    }()
    
    private let searchBar: UISearchBar = {
        let textField = UISearchBar()
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 15
        textField.placeholder = "Enter city name"
//        textField.textColor = .black
//        textField.textAlignment = .center
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
    
    private let searchView: UISearchLocationView = {
        let view = UISearchLocationView()
        return view
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
        
        setupSelf()
        setupSettingsImageView()
        setupSearchBar()
        setupSearchButton()
        setupLocationsCollectionView()
        setupDailyWeatherCollectionView()
        setupWeatherDetailsView()
        setupSearchView()
        
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.handleLocationPermission()
    }
    
    private func setupSelf() {
        self.view.backgroundColor = UIColor(red: 191, green: 181, blue: 180)

        let tapAnywhere = UIGestureRecognizer(target: self.weatherDetailsView, action: #selector(self.view.dismissKeyboad))
        tapAnywhere.cancelsTouchesInView = false
        self.weatherDetailsView.addGestureRecognizer(tapAnywhere)
    }
    
    private func setupSettingsImageView() {
        self.view.addSubview(settingsImageView)
        settingsImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(50)
        }
    }
    
    private func setupSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(settingsImageView.snp.trailing).offset(10)
            make.height.equalTo(50)
        }
    }
    
    private func setupSearchButton() {
        self.view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(searchBar)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(searchBar.snp.trailing).offset(20)
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
    
    private func setupSearchView() {
        self.view.addSubview(searchView)
        searchView.isHidden = true
        searchView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func updateWeatherViewState() {
        var imageName = ""
        switch weatherViewState {
        case .standart:
            imageName = "settings"
        case .searchingLocation:
            imageName = "cancel"
        }
        self.settingsImageView.image = UIImage(named: imageName)
    }
    
    private func setupGestureRecognizers() {
//        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
//        rightSwipeGestureRecognizer.direction = .right
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsButtonAction))
        settingsImageView.isUserInteractionEnabled = true
        self.settingsImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func settingsButtonAction() {
        if let presenter = presenter as? WeatherPresenter {
            switch weatherViewState {
            case .standart:
                presenter.openSettingsBlock()
            case .searchingLocation:
                self.endSearching()
            }
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
        print("NEW location: \(location.city)")
        self.changeWeather(for: location)
    }
    
    func updateNearbyCities(cities: [String]) {
        self.locationsCollectionView.reloadData()
    }
    
    func updateSearchedLocations(searchedLocations: [SearchLocation]) {
        print("search location updated")
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
        let location = UserLocation(city: searchBar.text!)
        presenter?.fetchWeather(location)
        presenter?.exploreForecast(location, days: 10)
        endSearching()
    }
    
    private func changeWeather(for location: UserLocation?) {
        guard let location = location else { return }
        presenter?.fetchWeather(location)
        presenter?.exploreForecast(location, days: 10)
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
    
    private func startSearching() {
        self.searchView.showWithAnimation()
        self.weatherViewState = .searchingLocation
    }
    
    private func endSearching() {
        self.searchView.hideWithAnimation()
        self.weatherViewState = .standart
        self.view.dismissKeyboad()
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

extension WeatherViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.startSearching()
        print("start")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endSearching()
        print("clickd")
    }
}
