//
//  Presenter.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation

// Object
// protocol
// ref  to interactor, router, view

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
}

protocol AnyWeatherPresenter: AnyPresenter {
    func fetchWeather(_ location: UserLocation)
    func interactorDidFetchWeather(with result: Result<Weather, Error>?)
    
    func exploreForecast(_ location: UserLocation, days: Int)
    func interactorDidExploreForecast(with result: Result<ForecastWeather, Error>?)
}

class WeatherPresenter: AnyWeatherPresenter {
    var router: AnyRouter?
    var interactor: AnyInteractor?
    
    var locationable: Locationable?
    
    var view: AnyView?
    
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
    
}
