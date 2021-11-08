//
//  ForecastDetailViewModelTest.swift
//  weatherTests
//
//  Created by Einstein Nguyen on 11/7/21.
//

import XCTest
@testable import weather

class ForecastDetailViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testForecastDetailViewModel() throws {
        let viewModel = ForecastDetailViewModel()
        
        XCTAssertTrue(viewModel.pickerStatuses == ["Fahrenheit", "Celsius"])
        XCTAssertTrue(viewModel.newTemp == UnitTemperature.fahrenheit)
        XCTAssertTrue(viewModel.blurEffect == UIBlurEffect(style: .light))
    }
}
