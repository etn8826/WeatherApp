//
//  ForecastHelperTest.swift
//  weatherTests
//
//  Created by Einstein Nguyen on 11/7/21.
//

import XCTest
@testable import weather
import MapKit

class ForecastHelperTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testConvertTemp() throws {
        let kelvinTemp = 299.9
        let fahrenheitTemp = 80.15
        let celsiusTemp = 26.75
        let fString = "80°F"
        let cString = "27°C"
        let kString = "300 K"
        
        let kToFTemp = ForecastHelper.convert(temp: Float(kelvinTemp), from: .kelvin, to: .fahrenheit)
        let kToCTemp = ForecastHelper.convert(temp: Float(kelvinTemp), from: .kelvin, to: .celsius)
        let fToKTemp = ForecastHelper.convert(temp: Float(fahrenheitTemp), from: .fahrenheit, to: .kelvin)
        let fToCTemp = ForecastHelper.convert(temp: Float(fahrenheitTemp), from: .fahrenheit, to: .celsius)
        let cToKTemp = ForecastHelper.convert(temp: Float(celsiusTemp), from: .celsius, to: .kelvin)
        let cToFTemp = ForecastHelper.convert(temp: Float(celsiusTemp), from: .celsius, to: .fahrenheit)
        
        XCTAssertTrue(kToFTemp == fString)
        XCTAssertTrue(kToCTemp == cString)
        XCTAssertTrue(fToKTemp == kString)
        XCTAssertTrue(fToCTemp == cString)
        XCTAssertTrue(cToFTemp == fString)
        XCTAssertTrue(cToKTemp == kString)
    }
    
    func testCalculateDirection() throws {
        let northDeg = 0
        let southDeg = 180
        let westDeg = 270
        let eastDeg = 90
        let neDeg = 45
        let seDeg = 135
        let swDeg = 225
        let nwDeg = 315
        let errorDeg = 99999
        
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: northDeg) == "N")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: southDeg) == "S")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: westDeg) == "W")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: eastDeg) == "E")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: swDeg) == "SW")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: seDeg) == "SE")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: neDeg) == "NE")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: nwDeg) == "NW")
        XCTAssertTrue(ForecastHelper.calculateDirection(deg: errorDeg) == "")
    }
}
