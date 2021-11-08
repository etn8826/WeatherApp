//
//  Clouds.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

struct Clouds: Decodable {
    enum CodingKeys: String, CodingKey {
        case all
    }

    var all: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.all      = try container.decode(Int.self, forKey: .all)
        
    }
}
