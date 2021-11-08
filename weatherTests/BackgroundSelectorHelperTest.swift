//
//  BackgroundSelectorHelperTest.swift
//  weatherTests
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import XCTest
@testable import weather

class BackgroundSelectorHelperTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testMainViewBackgroundSelector() throws {
        let dateString1 = "00:00"
        let dateString2 = "07:00"
        let dateString3 = "12:00"
        let dateString4 = "19:00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date1 = dateFormatter.date(from: dateString1) else { return }
        guard let date2 = dateFormatter.date(from: dateString2) else { return }
        guard let date3 = dateFormatter.date(from: dateString3) else { return }
        guard let date4 = dateFormatter.date(from: dateString4) else { return }

        let image1 = BackgroundSelectorHelper.mainViewBackgroundSelector(date: date1)
        let image2 = BackgroundSelectorHelper.mainViewBackgroundSelector(date: date2)
        let image3 = BackgroundSelectorHelper.mainViewBackgroundSelector(date: date3)
        let image4 = BackgroundSelectorHelper.mainViewBackgroundSelector(date: date4)
        
        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)
        XCTAssertNotNil(image3)
        XCTAssertNotNil(image4)
    }
    
    func testForecastBackgroundSelector() throws {
        let dateString1 = "00:00"
        let dateString2 = "07:00"
        let dateString3 = "12:00"
        let dateString4 = "19:00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date1 = dateFormatter.date(from: dateString1) else { return }
        guard let date2 = dateFormatter.date(from: dateString2) else { return }
        guard let date3 = dateFormatter.date(from: dateString3) else { return }
        guard let date4 = dateFormatter.date(from: dateString4) else { return }

        let image1 = BackgroundSelectorHelper.forecastDetailBackgroundSelector(date: date1, weather: "Clouds")
        let image2 = BackgroundSelectorHelper.forecastDetailBackgroundSelector(date: date2, weather: "Rain")
        let image3 = BackgroundSelectorHelper.forecastDetailBackgroundSelector(date:  date3, weather: "Clear")
        let image4 = BackgroundSelectorHelper.forecastDetailBackgroundSelector(date: date4, weather: "Snow")
        let image5 = BackgroundSelectorHelper.forecastDetailBackgroundSelector(date: date4, weather: "Clear")
        
        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)
        XCTAssertNotNil(image3)
        XCTAssertNotNil(image4)
        XCTAssertNotNil(image5)
    }
}
