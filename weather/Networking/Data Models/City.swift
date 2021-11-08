//
//  City.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct City: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coord
        case country
        case population
        case timezone
        case sunrise
        case sunset
    }

    var id: Int
    var name: String
    var coord: Location
    var country: String
    var population: Int
    var timezone: Int
    var sunrise: Int
    var sunset: Int

    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        self.id         = try container.decode(Int.self, forKey: .id)
        self.name       = try container.decode(String.self, forKey: .name)
        self.coord      = try container.decode(Location.self, forKey: .coord)
        self.country    = try container.decode(String.self, forKey: .country)
        self.population = try container.decode(Int.self, forKey: .population)
        self.timezone   = try container.decode(Int.self, forKey: .timezone)
        self.sunrise    = try container.decode(Int.self, forKey: .sunrise)
        self.sunset     = try container.decode(Int.self, forKey: .sunset)
        
    }
}
