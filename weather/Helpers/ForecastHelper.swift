//
//  ForecastHelper.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation
import MapKit

struct ForecastHelper {
    static func convert(temp: Float, from oldTemp: UnitTemperature, to newTemp: UnitTemperature) -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let oldTemp = Measurement(value: Double(temp), unit: oldTemp)
        let newTemp = oldTemp.converted(to: newTemp)
        return formatter.string(from: newTemp)
    }
    
    static func calculateDirection(deg: Int) -> String {
        switch deg {
        case let deg where (deg >= 345 && deg <= 360) || (deg <= 15 && deg <= 0):
            return "N"
        case 75...105:
            return "E"
        case 165...195:
            return "S"
        case 255...285:
            return "W"
        case 16...74:
            return "NE"
        case 106...164:
            return "SE"
        case 196...254:
            return "SW"
        case 286...344:
            return "NW"
        default:
            return ""
        }
    }
}
