//
//  ForecastViewModelTest.swift
//  weatherTests
//
//  Created by Einstein Nguyen on 11/7/21.
//

import XCTest
@testable import weather

class ForecastViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testForecastViewModel() throws {
        var viewModel = ForecastViewModel()
        
        XCTAssertTrue(viewModel.pickerStatuses == ["Fahrenheit", "Celsius"])
        XCTAssertTrue(viewModel.newTemp == UnitTemperature.fahrenheit)
        XCTAssertTrue(viewModel.blurEffect == UIBlurEffect(style: .light))
        XCTAssertTrue(viewModel.dateArray == [])
    }
}

