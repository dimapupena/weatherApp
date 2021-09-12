//
//  WeatherInteractor.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 22.06.2021.
//

import Foundation
import Alamofire

protocol WeatherPresenterToInteractor {
    var presenter: WeatherInteractorToPresenter? { get set }
    
    func getWeather(for location: UserLocation)
    func getWeatherForecast(for location: UserLocation, days: Int)
    func getNearbyCities(_ parameters: ParametersFindCitiesNearby)
    func searchLocationByPart(_ part: String)
}


class WeatherInteractor: WeatherPresenterToInteractor, WorkWithAPI {
    var presenter: WeatherInteractorToPresenter?
    private var curentSearchRequest: DataRequest?
    
    func getWeather(for location: UserLocation) {
        guard let urlComponents = getURLComponents(url: (WeatherAPIParameters.Endpoints.currentWeather.url)!, parameters: ["q" : "\(location.city)"]) else {
            presenter?.interactorDidFetchWeather(with: nil)
            return
        }
        AF.request(urlComponents.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { [weak self] response in
            guard let self = self else { return }
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
    
    func getWeatherForecast(for location: UserLocation, days: Int) {
        let parameters: [String: String] = ["q" : "\(location.city)",
                                            "days" : "10"]
        guard let urlComponents = getURLComponents(url: (WeatherAPIParameters.Endpoints.forecast.url!), parameters: parameters) else {
            return
        }
        
        AF.request(urlComponents.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { [weak self] response in
            guard let self = self else { return }
            let decoder = JSONDecoder()
            
            switch response.result {
            case .success:
                do {
                    let resultForecast = try decoder.decode(ForecastWeather.self, from: response.data!)
                    self.presenter?.interactorDidExploreForecast(with: .success(resultForecast))
                } catch  {
                    self.presenter?.interactorDidExploreForecast(with: nil)
                }
            default:
                self.presenter?.interactorDidExploreForecast(with: nil)
            }
        }
        
    }
    
    func getNearbyCities(_ parameters: ParametersFindCitiesNearby) {
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
    
    func searchLocationByPart(_ part: String) {
        self.curentSearchRequest?.cancel()
        let parameters: [String : String] = [ "q" : "\(part)"]
        guard let urlComponents = getURLComponents(url: WeatherAPIParameters.Endpoints.searchLocation.url!, parameters: parameters) else { return }
        self.curentSearchRequest = AF.request(urlComponents.url?.absoluteString as! URLConvertible, method: .get, headers: WeatherAPIParameters.headers).validate().responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: [])
                    let searchResult = try decoder.decode([SearchLocation].self, from: response.data!)
                    self.presenter?.interactorFetchedSearchedLocations(with: .success(searchResult))
                    print("Recieve data from search request")
                } catch {
                    self.presenter?.interactorFetchedSearchedLocations(with: .failure(error))
                }
            default:
                break
            }
        }
    }
}
