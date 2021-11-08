//
//  MainForecast.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct MainForecast: Decodable {
    enum CodingKeys: String, CodingKey {
        case temp
        case feels_like
        case temp_min
        case temp_max
        case pressure
        case sea_level
        case grnd_level
        case humidity
        case temp_kf
    }

    var temp: Float
    var feelsLike: Float
    var tempMin: Float
    var tempMax: Float
    var pressure: Int
    var seaLevel: Int
    var grndLevel: Int
    var humidity: Int
    var tempKF: Float

    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.temp      = try container.decode(Float.self, forKey: .temp)
        self.feelsLike = try container.decode(Float.self, forKey: .feels_like)
        self.tempMax   = try container.decode(Float.self, forKey: .temp_max)
        self.tempMin   = try container.decode(Float.self, forKey: .temp_min)
        self.pressure  = try container.decode(Int.self, forKey: .pressure)
        self.seaLevel  = try container.decode(Int.self, forKey: .sea_level)
        self.grndLevel = try container.decode(Int.self, forKey: .grnd_level)
        self.humidity  = try container.decode(Int.self, forKey: .humidity)
        self.tempKF    = try container.decode(Float.self, forKey: .temp_kf)
    }
}
