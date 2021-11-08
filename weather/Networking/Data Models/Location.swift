//
//  Location.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }

    var lat: Float
    var lon: Float

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat      = try container.decode(Float.self, forKey: .lat)
        self.lon      = try container.decode(Float.self, forKey: .lon)
        
    }
}
