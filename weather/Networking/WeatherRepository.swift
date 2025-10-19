//
//  WeatherRepository.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation
import CoreLocation

struct WeatherRepository {
    static func getWeatherForCity(coords: CLLocationCoordinate2D, onComplete: @escaping (Result<ForecastReponse, Error>) -> Void) {
        let path = "https://api.weather.gov/points/\(coords.latitude),\(coords.longitude)"
        guard let url = URL(string: path) else {
            let cityError = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "Can not get data for city entered"])
            onComplete(.failure(cityError))
            return
        }
        
        let onComplete: (Result<ForecastReponse, Error>) -> Void = { result in
            switch result {
            case .success(let hourlyForecast):
                onComplete(.success(hourlyForecast))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
        
        WebServiceManager.shared.performRequest(url, onComplete: onComplete)
    }
    
    static func getHourlyForecast(from urlString: String, onComplete: @escaping (Result<HourlyForecastResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let cityError = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "Can not get data for city entered"])
            onComplete(.failure(cityError))
            return
        }
        
        let onComplete: (Result<HourlyForecastResponse, Error>) -> Void = { result in
            switch result {
            case .success(let hourlyForecast):
                onComplete(.success(hourlyForecast))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
        
        WebServiceManager.shared.performRequest(url, onComplete: onComplete)
    }
}
