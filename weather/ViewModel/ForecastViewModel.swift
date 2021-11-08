//
//  ForecastViewModel.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import UIKit

struct ForecastViewModel {
    var cityForecast: CityForeCast?
    let pickerStatuses = ["Fahrenheit", "Celsius"]
    var newTemp: UnitTemperature = .fahrenheit
    let blurEffect = UIBlurEffect(style: .light)
    var blurEffectView = UIVisualEffectView()
    
    lazy var dateArray: [String] = {
        guard let forecast = cityForecast else { return [] }
        var dateArray: [String] = []
        for item in forecast.list {
            let dateString = DateHelper.convertDTToString(dt: item.dt, format: .date)
            dateArray.append(dateString)
        }
        guard let uniqueOrdered = Array(NSOrderedSet(array: dateArray)) as? [String]
        else { return [] }
        return uniqueOrdered
    }()
}
