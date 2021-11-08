//
//  ForecastDetailViewModel.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import UIKit

struct ForecastDetailViewModel {
    var forecast: Forecast?
    var cityName: String?
    let pickerStatuses = ["Fahrenheit", "Celsius"]
    var newTemp: UnitTemperature = .fahrenheit
    let blurEffect = UIBlurEffect(style: .light)
    var blurEffectView = UIVisualEffectView()
}
