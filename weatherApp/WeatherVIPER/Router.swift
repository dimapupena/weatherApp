//
//  Router.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import UIKit

// Object
// Entry point

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entryViewController: EntryPoint? { get }
    
    static func start() -> AnyRouter
}

protocol AnyWeatherRouter: AnyRouter {

}

class WeatherRouter: AnyWeatherRouter {
    var entryViewController: EntryPoint?
    
    static func start() -> AnyRouter {
        let router = WeatherRouter()
        
        var view: AnyView = WeatherViewController()
        var presenter: AnyWeatherPresenter = WeatherPresenter()
        var interactor: AnyInteractor = WeatherInteractor()
        let locationManager: Locationable = LocationManager()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        if let weatherPresenter = presenter as? WeatherPresenter {
            weatherPresenter.locationable = locationManager
        }
        
        router.entryViewController = view as? EntryPoint
        
        return router
    }
}
