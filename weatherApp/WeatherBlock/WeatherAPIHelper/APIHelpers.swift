//
//  APIHelpers.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 03.09.2021.
//

import Foundation
import Alamofire

protocol ApiParameters {
    static var headers: HTTPHeaders { get set }
    
}

protocol WorkWithAPI {
    
}

extension WorkWithAPI {
    func getURLComponents(url: URL, parameters: [String: String]) -> URLComponents? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = [URLQueryItem]()
        for parameter in parameters {
            urlComponents.queryItems?.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        return urlComponents
    }
}
