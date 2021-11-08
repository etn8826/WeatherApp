//
//  DateHelper.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation

struct DateHelper {
    
    enum DateFormat: String {
        case date = "EEEE, MMMM d"
        case time = "h:mm a"
        case dateTime = "EEEE, MMMM d\nhh:mm a"
    }
    static func convertDTToString(dt: Int, format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
}
