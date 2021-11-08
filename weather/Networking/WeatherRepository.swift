//
//  WeatherRepository.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct WeatherRepository {
    static func getWeatherForCity(city: String, success: @escaping (CityForeCast) -> Void, failure: @escaping (Error) -> Void) {
        let queryString = city.replacingOccurrences(of: " ", with: "+")
        let appId = "65d00499677e59496ca2f318eb68c049"
        let path = "https://api.openweathermap.org/data/2.5/forecast?q=\(queryString)&appid=\(appId)"
        guard let url = URL(string: path) else {
            let cityError = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "Can not get data for city entered"])
            failure(cityError)
            return
        }
        
        let getSuccess: (Data) -> Void = { data in
            do {
                let cityForecast = try JSONDecoder().decode(CityForeCast.self, from: data)
                success(cityForecast)
            } catch let error {
                failure(error)
            }
        }
        
        let getFailure: (Error) -> Void = { error in
            failure(error)
        }
        
        WebServiceManager.shared.makeRequest(url, success: getSuccess, failure: getFailure)
    }
}
