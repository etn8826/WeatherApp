//
//  DateHelperTest.swift
//  weatherTests
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import XCTest
@testable import weather

class DateHelperTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testconvertDTToString() throws {
        let dateFormat = "EEEE, MMMM d"
        let timeFormat = "h:mm a"
        let dateTimeForamt = "EEEE, MMMM d\nhh:mm a"
        let date = Date()
        let timeInt1970 = date.timeIntervalSince1970
        let sutDateString = DateHelper.convertDTToString(dt: Int(timeInt1970), format: .date)
        let sutTimeString = DateHelper.convertDTToString(dt: Int(timeInt1970), format: .time)
        let sutDateTimeString = DateHelper.convertDTToString(dt: Int(timeInt1970), format: .dateTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = dateTimeForamt
        let dateTimeString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = timeFormat
        let timeString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: date)
        
        XCTAssertTrue(sutDateString == dateString)
        XCTAssertTrue(sutDateTimeString == dateTimeString)
        XCTAssertTrue(sutTimeString == timeString)
    }
}
