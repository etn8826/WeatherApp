//
//  MainViewModel.swift
//  weather
//
//  Created by Einstein Nguyen on 10/9/25.
//

import Foundation
import CoreLocation

class MainViewModel {
    var onForecastFetched: ((HourlyForecastResponse, RelativeLocationProperties, String) -> Void)?
    var onError: ((Error) -> Void)?
    
    func getForecast(cityState: String) {
        print("Searching for city/state: \(cityState)")
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
            
            self.getForecast(location: [location], cityState: cityState)
        }
    }
    
    func getForecast(location: [CLLocation], cityState: String? = nil) {
        guard let gpsLocation = location.last else { return }
        WeatherRepository.getWeatherForCity(
            coords: gpsLocation.coordinate,
            onComplete: { [weak self] result in
                switch result {
                case .success(let forecastResponse):
                    WeatherRepository.getHourlyForecast(from: forecastResponse.properties.forecastHourly, onComplete: { [weak self] result in
                        switch result {
                        case .success(let hourlyForecast):
                            var trimmedCityState: String?
                            if let newCityState = cityState {
                                trimmedCityState = self?.trimCityState(input: newCityState)
                            }
                            let relativeLocation = RelativeLocationProperties(city: trimmedCityState?.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? forecastResponse.properties.relativeLocation.properties.city,
                                                                              state: trimmedCityState?.components(separatedBy: ",").last?.trimmingCharacters(in: .whitespaces) ?? forecastResponse.properties.relativeLocation.properties.state)
                            self?.onForecastFetched?(hourlyForecast, relativeLocation, forecastResponse.properties.forecastHourly)
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
    
    private func trimCityState(input: String) -> String? {
        if let match = input.range(of: #"^[^,]+,\s*[A-Z]{2}"#, options: .regularExpression) {
            let cityState = String(input[match])
            print(cityState)
            return cityState
        }
        return nil
    }
}
