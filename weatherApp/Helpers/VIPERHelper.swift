//
//  VIPERHelper.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 05.09.2021.
//

import Foundation
import UIKit

protocol AnyInteractor: AnyObject {
    var presenter: AnyPresenter? { get set }
}

// Object
// protocol
// ref  to interactor, router, view

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
}

// Object
// Entry point

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entryViewController: EntryPoint? { get }
    
    static func start() -> AnyRouter
}
