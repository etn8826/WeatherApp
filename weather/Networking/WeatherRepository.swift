//
//  WeatherRepository.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation
import CoreLocation

struct WeatherRepository {
    static func getWeatherForCity(coords: CLLocationCoordinate2D, success: @escaping (ForecastReponse) -> Void, failure: @escaping (Error) -> Void) {
        let path = "https://api.weather.gov/points/\(coords.latitude),\(coords.longitude)"
        guard let url = URL(string: path) else {
            let cityError = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "Can not get data for city entered"])
            failure(cityError)
            return
        }
        
        let getSuccess: (Data) -> Void = { data in
            do {
                let hourlyForecast = try JSONDecoder().decode(ForecastReponse.self, from: data)
                success(hourlyForecast)
            } catch let error {
                failure(error)
            }
        }
        
        let getFailure: (Error) -> Void = { error in
            failure(error)
        }
        
        WebServiceManager.shared.makeRequest(url, success: getSuccess, failure: getFailure)
    }
    
    static func getHourlyForecast(from urlString: String, success: @escaping (HourlyForecastResponse) -> Void, failure: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else {
            let cityError = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "Can not get data for city entered"])
            failure(cityError)
            return
        }
        
        let getSuccess: (Data) -> Void = { data in
            do {
                let hourlyForecast = try JSONDecoder().decode(HourlyForecastResponse.self, from: data)
                success(hourlyForecast)
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
