//
//  MainViewModel.swift
//  weather
//
//  Created by Einstein Nguyen on 10/9/25.
//

import Foundation
import CoreLocation

class MainViewModel {
    var onForecastFetched: ((HourlyForecastResponse) -> Void)?
    var onError: ((Error) -> Void)?
    
    func getForecast(cityState: String) {
        MainViewInteractor.getForecastWithSearchResults(
            cityState: cityState,
            success: { [weak self] cityForecast in
                self?.onForecastFetched?(cityForecast)
            },
            failure: { [weak self] error in
                self?.onError?(error)
            }
        )
    }
    
    func getForecast(location: [CLLocation]) {
        MainViewInteractor.getForecastWithUserLocation(
            locations: location,
            success: { [weak self] cityForecast in
                self?.onForecastFetched?(cityForecast)
            },
            failure: { [weak self] error in
                self?.onError?(error)
            }
        )
    }
}
