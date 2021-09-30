//
//  WeatherRouter.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import UIKit

typealias EntryPoint = UIViewController & UIViewController

protocol WeatherPresenterToRouter {
    var entryViewController: EntryPoint? { get }
    
    static func start() -> WeatherPresenterToRouter
}

class WeatherRouter: WeatherPresenterToRouter {
    var openSettingsBlock: (() -> Void)?
    var openUserMapBlock: (() -> Void)?
        
    var entryViewController: EntryPoint?
    
    static func start() -> WeatherPresenterToRouter {
        let router = WeatherRouter()
        
        let view = WeatherViewController()
        var presenter: WeatherViewToPresenter & WeatherInteractorToPresenter = WeatherPresenter()
        var interactor: WeatherPresenterToInteractor = WeatherInteractor()
        let locationManager: Locationable = LocationManager()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        if let weatherPresenter = presenter as? WeatherPresenter {
            weatherPresenter.locationable = locationManager
            weatherPresenter.setupListeners()
        }
        
        router.entryViewController = view as? EntryPoint
        
        return router
    }
}
