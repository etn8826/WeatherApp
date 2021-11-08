//
//  Wind.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct Wind: Decodable {
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
        case gust
    }

    var speed: Float
    var deg: Int
    var gust: Float

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed    = try container.decode(Float.self, forKey: .speed)
        self.deg      = try container.decode(Int.self, forKey: .deg)
        self.gust     = try container.decode(Float.self, forKey: .gust)
    }
}
