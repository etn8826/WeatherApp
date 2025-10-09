//
//  Forecast.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct Forecast: Decodable {
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case dt_txt
    }

    var dt: Int
    var main: MainForecast
    var weather: [Weather]
    var clouds: Clouds
    var wind: Wind
    var visibility: Int
    var pop: Float
    var dtTxt: String

    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        self.dt         = try container.decode(Int.self, forKey: .dt)
        self.main       = try container.decode(MainForecast.self, forKey: .main)
        self.weather    = try container.decode([Weather].self, forKey: .weather)
        self.clouds     = try container.decode(Clouds.self, forKey: .clouds)
        self.wind       = try container.decode(Wind.self, forKey: .wind)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.pop        = try container.decode(Float.self, forKey: .pop)
        self.dtTxt      = try container.decode(String.self, forKey: .dt_txt)
        
    }
}

struct ForecastReponse: Codable {
    let properties: Properties
}

struct Properties: Codable {
    let forecastHourly: String
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
}
