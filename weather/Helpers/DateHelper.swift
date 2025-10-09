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
    static func convertDTToString(dateString: String, format: DateFormat) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) ?? ISO8601DateFormatter().date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = format.rawValue
            return displayFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
