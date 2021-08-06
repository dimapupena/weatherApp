//
//  Interactor.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import Alamofire

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getWeather(for name: String)
}

class WeatherInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getWeather(for name: String = "Paris") {
        guard let urlComponents = URLComponents(url: (WeatherAPIParameters.Endpoints.currentWeather.url)!, resolvingAgainstBaseURL: false) else { self.presenter?.interactorDidFetchWeather(with: nil); return }
        
        var finalUrl = URLComponents(url: urlComponents.url!, resolvingAgainstBaseURL: false)
        finalUrl?.queryItems = [URLQueryItem]()
        finalUrl?.queryItems?.append(URLQueryItem(name: "q", value: name))
        AF.request(finalUrl?.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { response in
            let decoder = JSONDecoder()
            
            switch response.result {
            case .success:
                do {
                    // cannot pars it((
                    let resultWeather = try decoder.decode(Weather.self, from: response.data!)
                    self.presenter?.interactorDidFetchWeather(with: .success(resultWeather))
                } catch {
                    self.presenter?.interactorDidFetchWeather(with: nil)
                    print("error")
                }
                print("success")
            default:
                self.presenter?.interactorDidFetchWeather(with: nil)
                print("error")
            }
        }
    }
}
