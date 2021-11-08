//
//  Weather.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct Weather: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }

    var id: Int
    var main: String
    var description: String
    var icon: String
    
    init(from decoder: Decoder) throws {
        let container    = try decoder.container(keyedBy: CodingKeys.self)
        self.id          = try container.decode(Int.self, forKey: .id)
        self.main        = try container.decode(String.self, forKey: .main)
        self.description = try container.decode(String.self, forKey: .description)
        self.icon        = try container.decode(String.self, forKey: .icon)
    }
}
