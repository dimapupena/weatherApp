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
    
    func fetchWeather()
    func interactorDidFetchWeather(with result: Result<Weather, Error>?)
}

class WeatherPresenter: AnyPresenter {
    var router: AnyRouter?
    
    var interactor: AnyInteractor?
    
    var view: AnyView?
    
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
    
    func fetchWeather() {
        interactor?.getWeather(for: "Paris")
    }
    
}
