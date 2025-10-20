//
//  ForecastViewModel.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation

struct ForecastViewModel {
    var cityForecast: HourlyForecastResponse?
    var cityState: RelativeLocationProperties?
    let pickerStatuses = ["Fahrenheit", "Celsius"]
    var newTemp: UnitTemperature = .fahrenheit
    
    struct DaySection {
        let date: Date
        let weathers: [Periods]
    }
    
    let isoFormatter = ISO8601DateFormatter()
    
    lazy var dateArray: [DaySection] = {
        guard let forecasts = cityForecast?.properties.periods else { return [] }
        
        let grouped = Dictionary(grouping: forecasts) { forecast -> Date in
            // Convert string → Date
            guard let date = isoFormatter.date(from: forecast.startTime) else {
                return Date.distantPast
            }
            // Normalize to just year-month-day
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            return Calendar.current.date(from: components)!
        }
        
        let sortedDays = grouped.keys.sorted()
        return sortedDays.map { DaySection(date: $0, weathers: grouped[$0]!.sorted {
            isoFormatter.date(from: $0.startTime)! < isoFormatter.date(from: $1.startTime)!
        })}
    }()
}
