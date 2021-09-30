//
//  ApplicationCoordinator.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 05.09.2021.
//

import Foundation
import UIKit

protocol AnyCoordinator {
    var router: UINavigationController {get set}
    func start()
}

class ApplicationCoordinator: AnyCoordinator {
    var router: UINavigationController
    
    init(router: UINavigationController) {
        self.router = router
    }
    
    func start() {
        startWeatherBlock()
    }
    
    private func startWeatherBlock() {
        let weatherRouter = WeatherRouter.start() as? WeatherRouter
        weatherRouter?.openSettingsBlock = {
            self.startSettingsBlock()
        }
        weatherRouter?.openUserMapBlock = {
            self.startUserMapBlock()
        }
        if let initialVC = weatherRouter?.entryViewController {
            router.pushViewController(initialVC, animated: true)
        }
    }
    
    private func startSettingsBlock() {
        let settingsVC = SettingsViewController()
        settingsVC.onFinish = { [weak self] in
            self?.router.popViewController(animated: true)
        }
        router.pushViewController(settingsVC, animated: true)
    }
    
    private func startUserMapBlock() {
        let mapVC = UserMapViewController()
        mapVC.onFinish = { [weak self] in
            self?.router.popViewController(animated: true)
        }
        router.pushViewController(mapVC, animated: true)
    }
    
}
