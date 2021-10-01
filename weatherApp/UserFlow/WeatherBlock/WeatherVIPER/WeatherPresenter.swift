//
//  WeatherPresenter.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import CoreLocation

protocol WeatherViewToPresenter {
    var router: WeatherPresenterToRouter? { get set }
    var interactor: WeatherPresenterToInteractor? { get set }
    var view: WeatherPresenterToView? { get set }
    
    func fetchWeather(_ location: UserLocation)
    func exploreForecast(_ location: UserLocation, days: Int)
    func exploreNearbyCities(_ parameters: ParametersFindCitiesNearby)
    func exploredLocaiton(location: UserLocation, locationData: CLLocation?)
    func trySearchLocation(part: String)
}

protocol WeatherInteractorToPresenter {
    func interactorDidFetchWeather(with result: Result<Weather, Error>?)
    func interactorDidExploreForecast(with result: Result<ForecastWeather, Error>?)
    func interactorHasExploredNearbyCities(cities: [String])
    func interactorFetchedSearchedLocations(with result: Result<[SearchLocation], Error>?)
}

class WeatherPresenter: WeatherViewToPresenter {
    var router: WeatherPresenterToRouter?
    var interactor: WeatherPresenterToInteractor?
    var view: WeatherPresenterToView?
    
    var locationable: Locationable?
    
    func setupListeners() {
        self.locationable?.delegate = self
    }
    
    func fetchWeather(_ location: UserLocation) {
        interactor?.getWeather(for: location)
    }
    
    func exploreForecast(_ location: UserLocation, days: Int = 10) {
        interactor?.getWeatherForecast(for: location, days: days)
    }
    
    func exploreNearbyCities(_ parameters: ParametersFindCitiesNearby) {
        interactor?.getNearbyCities(parameters)
    }
    
    func exploredLocaiton(location: UserLocation, locationData: CLLocation?) {
        view?.locationWasUpdated(to: location)
        if let locationData = locationData {
            let findCitiesParameters = ParametersFindCitiesNearby(latitude: Decimal(locationData.coordinate.latitude), longitude: Decimal(locationData.coordinate.longitude), radius: 100, minPopulation: 50000, maxPopulation: 100000000)
            self.exploreNearbyCities(findCitiesParameters)
        }
    }
    
    func openSettingsBlock()  {
        if let router = router as? WeatherRouter {
            router.openSettingsBlock?()
        }
    }
    
    func openUserMapBlock(_ startLocation: CLLocation?) {
        if let router = router as? WeatherRouter {
            router.openUserMapBlock?(startLocation)
        }
    }
    
    func trySearchLocation(part: String) {
        guard let interactor = interactor as? WeatherInteractor else { return }
        interactor.searchLocationByPart(part)
    }
}

extension WeatherPresenter: WeatherInteractorToPresenter {
    
    func interactorDidFetchWeather(with result: Result<Weather, Error>?) {
        switch result {
        case .success(let weather):
            view?.updateWeahter(with: weather)
        case .failure:
            view?.updateWeahterWithError(with: nil)
        case .none:
            view?.updateWeahterWithError(with: nil)
        }
    }
    
    func interactorDidExploreForecast(with result: Result<ForecastWeather, Error>?) {
        switch result {
        case .success(let forecast):
            view?.updateForecastWeahter(with: forecast)
        default:
            view?.updateWeahterWithError(with: nil)
        }
    }
    
    func interactorHasExploredNearbyCities(cities: [String]) {
        view?.updateNearbyCities(cities: cities)
    }
    
    func interactorFetchedSearchedLocations(with result: Result<[SearchLocation], Error>?) {
        switch result {
        case .success(let locations):
            view?.updateSearchedLocations(searchedLocations: locations)
        default:
            view?.updateWeahterWithError(with: nil)
        }
    }
    
}

extension WeatherPresenter: LocationManagerDelegate {
    func locationWasUpdated(to location: UserLocation, locationData: CLLocation?) {
        self.exploredLocaiton(location: location, locationData: locationData)
    }
}
