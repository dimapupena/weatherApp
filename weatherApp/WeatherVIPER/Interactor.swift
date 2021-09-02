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
}

protocol AnyWeatherInteractor: AnyInteractor {
    func getWeather(for location: UserLocation)
    func getWeatherForecast(for location: UserLocation, days: Int)
}

class WeatherInteractor: AnyWeatherInteractor {
    var presenter: AnyPresenter?
    
    func getWeather(for location: UserLocation) {
        if let weatherPresenter = presenter as? AnyWeatherPresenter {
            guard let urlComponents = URLComponents(url: (WeatherAPIParameters.Endpoints.currentWeather.url)!, resolvingAgainstBaseURL: false) else {weatherPresenter.interactorDidFetchWeather(with: nil); return }
            
            var finalUrl = URLComponents(url: urlComponents.url!, resolvingAgainstBaseURL: false)
            finalUrl?.queryItems = [URLQueryItem]()
            finalUrl?.queryItems?.append(URLQueryItem(name: "q", value: location.city))
            AF.request(finalUrl?.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { response in
                let decoder = JSONDecoder()
                
                switch response.result {
                case .success:
                    do {
                        // cannot pars it((
                        let resultWeather = try decoder.decode(Weather.self, from: response.data!)
                        weatherPresenter.interactorDidFetchWeather(with: .success(resultWeather))
                    } catch {
                        weatherPresenter.interactorDidFetchWeather(with: nil)
                        print("error")
                    }
                    print("success")
                default:
                    weatherPresenter.interactorDidFetchWeather(with: nil)
                    print("error")
                }
            }
        }
    }
    
    func getWeatherForecast(for location: UserLocation, days: Int) {
        if let weatherPresenter = presenter as? AnyWeatherPresenter {
            guard let urlComponents = URLComponents(url: (WeatherAPIParameters.Endpoints.forecast.url)!, resolvingAgainstBaseURL: false) else { return }
            var finalUrl = URLComponents(url: urlComponents.url!, resolvingAgainstBaseURL: false)
            finalUrl?.queryItems = [URLQueryItem]()
            finalUrl?.queryItems?.append(URLQueryItem(name: "q", value: location.city))
            finalUrl?.queryItems?.append(URLQueryItem(name: "days", value: "10"))
            
            AF.request(finalUrl?.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { response in
                let decoder = JSONDecoder()
                
                switch response.result {
                case .success:
                    do {
                        let resultForecast = try decoder.decode(ForecastWeather.self, from: response.data!)
                        weatherPresenter.interactorDidExploreForecast(with: .success(resultForecast))
                    } catch  {
                        weatherPresenter.interactorDidExploreForecast(with: nil)
                    }
                default:
                    weatherPresenter.interactorDidExploreForecast(with: nil)
                }
            }

        }
    }
}
