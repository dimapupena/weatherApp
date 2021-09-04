//
//  WeatherPresenter.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import CoreLocation

protocol AnyWeatherPresenter: AnyPresenter {
    func fetchWeather(_ location: UserLocation)
    func interactorDidFetchWeather(with result: Result<Weather, Error>?)
    
    func exploreForecast(_ location: UserLocation, days: Int)
    func interactorDidExploreForecast(with result: Result<ForecastWeather, Error>?)
    
    func exploreNearbyCities(_ parameters: ParametersFindCitiesNearby)
    func interactorHasExploredNearbyCities(cities: [String])

    func exploredLocaiton(location: UserLocation, locationData: CLLocation?)
}

class WeatherPresenter: AnyWeatherPresenter {
    var router: AnyRouter?
    var interactor: AnyInteractor?
    
    var locationable: Locationable?
    
    var view: AnyView?
    
    func setupListeners() {
        self.locationable?.delegate = self
    }
    
    func interactorDidFetchWeather(with result: Result<Weather, Error>?) {
        guard let view = view as? AnyWeatherView else { return }
        switch result {
        case .success(let weather):
            view.updateWeahter(with: weather)
        case .failure:
            view.updateWeahterWithError(with: nil)
        case .none:
            view.updateWeahterWithError(with: nil)
        }
    }
    
    func fetchWeather(_ location: UserLocation) {
        guard let interactor = interactor as? AnyWeatherInteractor else { return }
        interactor.getWeather(for: location)
    }
    
    func interactorDidExploreForecast(with result: Result<ForecastWeather, Error>?) {
        guard let view = view as? AnyWeatherView else { return }
        switch result {
        case .success(let forecast):
            view.updateForecastWeahter(with: forecast)
        default:
            view.updateWeahterWithError(with: nil)
        }
    }
    
    func exploreForecast(_ location: UserLocation, days: Int = 10) {
        guard let interactor = interactor as? AnyWeatherInteractor else { return }
        interactor.getWeatherForecast(for: location, days: days)
    }
    
    func exploreNearbyCities(_ parameters: ParametersFindCitiesNearby) {
        guard let interactor = interactor as? AnyWeatherInteractor else { return }
        interactor.getNearbyCities(parameters)
    }
    
    func interactorHasExploredNearbyCities(cities: [String]) {
        guard let view = view as? AnyWeatherView else { return }
        view.updateNearbyCities(cities: cities)
    }
    
    
    func exploredLocaiton(location: UserLocation, locationData: CLLocation?) {
        guard let view = view as? AnyWeatherView else { return }
        view.locationWasUpdated(to: location)
        if let locationData = locationData {
            let findCitiesParameters = ParametersFindCitiesNearby(latitude: Decimal(locationData.coordinate.latitude), longitude: Decimal(locationData.coordinate.longitude), radius: 100, minPopulation: 50000, maxPopulation: 100000000)
            self.exploreNearbyCities(findCitiesParameters)
        }
    }
    
}

extension WeatherPresenter: LocationManagerDelegate {
    func locationWasUpdated(to location: UserLocation, locationData: CLLocation?) {
        self.exploredLocaiton(location: location, locationData: locationData)
    }
}
