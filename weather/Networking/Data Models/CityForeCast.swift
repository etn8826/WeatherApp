//
//  CityForeCast.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct CityForeCast: Decodable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: [Forecast]
    var city: City


    enum CodingKeys: String, CodingKey {
        case cod
        case message
        case cnt
        case list
        case city
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cod      = try container.decode(String.self, forKey: .cod)
        self.message  = try container.decode(Int.self, forKey: .message)
        self.cnt      = try container.decode(Int.self, forKey: .cnt)
        self.list     = try container.decode([Forecast].self, forKey: .list)
        self.city     = try container.decode(City.self, forKey: .city)
    }
}
