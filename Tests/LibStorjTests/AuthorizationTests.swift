//
// Created by Koray Koska on 20/06/2017.
//

import XCTest
@testable import LibStorj

class AuthorizationTests: XCTestCase {

    static let allTests = [
        ("testLogin", testLogin)
    ]

    func testLogin() throws {
        let test = "r"
        XCTAssertEqual(test, "r")
    }
}
