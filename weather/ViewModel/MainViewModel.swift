//
//  MainViewModel.swift
//  weather
//
//  Created by Einstein Nguyen on 10/9/25.
//

import Foundation
import CoreLocation

class MainViewModel {
    var onForecastFetched: ((HourlyForecastResponse, RelativeLocationProperties) -> Void)?
    var onError: ((Error) -> Void)?
    
    func getForecast(cityState: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityState) { placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("No location found")
                return
            }
            
            self.getForecast(location: [location])
        }
    }
    
    func getForecast(location: [CLLocation]) {
        guard let gpsLocation = location.last else { return }
        WeatherRepository.getWeatherForCity(
            coords: gpsLocation.coordinate,
            onComplete: { [weak self] result in
                switch result {
                case .success(let forecastResponse):
                    WeatherRepository.getHourlyForecast(from: forecastResponse.properties.forecastHourly, onComplete: { [weak self] result in
                        switch result {
                        case .success(let hourlyForecast):
                            self?.onForecastFetched?(hourlyForecast, forecastResponse.properties.relativeLocation.properties)
                        case .failure(let error):
                            self?.onError?(error)
                        }
                    })
                case .failure(let error):
                        self?.onError?(error)
                }
            }
        )
    }
}
