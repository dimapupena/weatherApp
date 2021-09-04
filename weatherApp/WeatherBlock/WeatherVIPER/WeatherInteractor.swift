//
//  WeatherInteractor.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import Alamofire

protocol AnyWeatherInteractor: AnyInteractor {
    func getWeather(for location: UserLocation)
    func getWeatherForecast(for location: UserLocation, days: Int)
    func getNearbyCities(_ parameters: ParametersFindCitiesNearby)
}

class WeatherInteractor: AnyWeatherInteractor, WorkWithAPI {
    var presenter: AnyPresenter?
    
    func getWeather(for location: UserLocation) {
        if let weatherPresenter = presenter as? AnyWeatherPresenter {
            guard let urlComponents = getURLComponents(url: (WeatherAPIParameters.Endpoints.currentWeather.url)!, parameters: ["q" : "\(location.city)"]) else {
                weatherPresenter.interactorDidFetchWeather(with: nil)
                return
            }
            AF.request(urlComponents.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { response in
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
            let parameters: [String: String] = ["q" : "\(location.city)",
                                              "days" : "10"]
            guard let urlComponents = getURLComponents(url: (WeatherAPIParameters.Endpoints.forecast.url!), parameters: parameters) else {
                return
            }
            
            AF.request(urlComponents.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { response in
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
    
    func getNearbyCities(_ parameters: ParametersFindCitiesNearby) {
        if let presenter = presenter as? AnyWeatherPresenter {
            let parameters: [String : String] =   ["latitude" : "\(parameters.latitude)",
                                                   "longitude" : "\(parameters.longitude)",
                                                   "radius" : "\(String(describing: parameters.radius ?? 0))",
                                                   "min_population" : "\(String(describing: parameters.minPopulation ?? 0))",
                                                   "max_population" : "\(String(describing: parameters.maxPopulation ?? 0))"]
            guard let urlComponents = getURLComponents(url: CitiesApiParameters.Endpoints.citiesNearby.url!, parameters: parameters)  else { return }
            AF.request(urlComponents.url?.absoluteString as! URLConvertible, method: .get, headers: CitiesApiParameters.headers).validate().responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let data = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    } catch {
                        
                    }
                default:
                    break
                }
            }
        }
    }
}
