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
    static func getForecastWithUserLocation(locations: [CLLocation], success: @escaping (CityForeCast) -> (Void), failure: @escaping (Error) -> (Void)) {
        guard let gpsLocation = locations.last else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(gpsLocation, preferredLocale: .current) { placemarks, error in
            if let error = error {
                failure(error)
            }
            guard let placemark = placemarks?[0],
                  let city = placemark.locality
            else { return }

            WeatherRepository.getWeatherForCity(
                city: city,
                success: { cityForecast in
                    success(cityForecast)
                },
                failure: { error in
                    failure(error)
                }
            )
        }
    }
    
    static func getForecastWithSearchResults(searchResults: [MKLocalSearchCompletion], row: Int, success: @escaping (CityForeCast) -> (Void), failure: @escaping (Error) -> (Void)) {
        let searchRequest = MKLocalSearch.Request(completion: searchResults[row])
        let cityComponents = searchRequest.naturalLanguageQuery?.components(separatedBy: ",")
        let city = cityComponents?[0]
        WeatherRepository.getWeatherForCity(
            city: city ?? "",
            success: { cityForecast in
                success(cityForecast)
            },
            failure: { error in
                failure(error)
            }
        )
    }
}
