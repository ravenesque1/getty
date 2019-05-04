//
//  gettyTests.swift
//  gettyTests
//
//  Created by Raven Weitzel on 5/2/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import XCTest
@testable import getty

class gettyTests: XCTestCase {

    func testFailIncorrectUrl() {

        let url = "https://api.yel.com/v3/businesses/zRlDhJgcwXEphTUhMaCfyw"

        let promise = expectation(description: "Completion called")
        var responseError: Error?

        GettyService.shared.fetch(url: url) { data, error in
            responseError = error
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(responseError)
    }

    func testParseBusinessData() {
        guard let data = try? Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "getty", withExtension: "json")!) else {
            XCTFail()
            return
        }

        let business = try? JSONDecoder().decode(Business.self, from: data)
        XCTAssertNotNil(business)
    }

    func testParseReviewData() {
        guard let data = try? Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "getty-reviews", withExtension: "json")!) else {
            XCTFail()
            return
        }

        let reviews = try? JSONDecoder().decode(ReviewResponse.self, from: data)
        XCTAssertNotNil(reviews)
    }
}
