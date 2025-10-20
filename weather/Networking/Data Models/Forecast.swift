//
//  Forecast.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct ForecastReponse: Codable {
    let properties: Properties
}

struct Properties: Codable {
    let forecastHourly: String
    let relativeLocation: RelativeLocation
}

struct RelativeLocation: Codable {
    let properties: RelativeLocationProperties
}

struct RelativeLocationProperties: Codable {
    let city: String
    let state: String
}

struct HourlyForecastResponse: Codable {
    let properties: HourlyForecastProperties
}

struct HourlyForecastProperties: Codable {
    let periods: [Periods]
}

struct Periods: Codable {
    let startTime: String
    let endTime: String
    let temperature: Int
    let temperatureUnit: String
    let windSpeed: String
    let windDirection: String
    let icon: String
    let shortForecast: String
    let probabilityOfPrecipitation: ProbabilityOfPrecipitation
}

struct ProbabilityOfPrecipitation: Codable {
    let value: Int
}
