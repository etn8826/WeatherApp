//
//  MainViewInteractor.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import CoreLocation
import MapKit

struct MainViewInteractor {
    static func getForecastWithUserLocation(locations: [CLLocation], success: @escaping (HourlyForecastResponse) -> (Void), failure: @escaping (Error) -> (Void)) {
        guard let gpsLocation = locations.last else { return }
        WeatherRepository.getWeatherForCity(
            coords: gpsLocation.coordinate,
            success: { result in
                WeatherRepository.getHourlyForecast(from: result.properties.forecastHourly, success: { hourlyForecast in
                    success(hourlyForecast)
                }, failure: { error in
                    failure(error)
                })
            },
            failure: { error in
                failure(error)
            }
        )
    }
    
    static func getForecastWithSearchResults(cityState: String, success: @escaping (HourlyForecastResponse) -> (Void), failure: @escaping (Error) -> (Void)) {
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
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("Coordinates: \(latitude), \(longitude)")
            WeatherRepository.getWeatherForCity(
                coords: location.coordinate,
                success: { result in
                    WeatherRepository.getHourlyForecast(from: result.properties.forecastHourly,success: { hourlyForecast in
                        success(hourlyForecast)
                    }, failure: { error in
                        failure(error)
                    })
                },
                failure: { error in
                    failure(error)
                }
            )
        }
    }
}
