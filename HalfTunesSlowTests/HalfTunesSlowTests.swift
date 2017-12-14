//
//  HalfTunesSlowTests.swift
//  HalfTunesSlowTests
//
//  Created by Gleb on 13.12.17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesSlowTests: XCTestCase {

    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testValidCallToiTunesGetsHTTPStatusCode200() {
        //given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")

        let promise = expectation(description: "Status code: 200")

        //when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }

    }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCallToiTunesCompletes() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")

        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error

            promise.fulfill()
        }
        dataTask.resume()

        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)

    }
    
}
