//
// Created by Koray Koska on 20/06/2017.
//

import XCTest
@testable import LibStorj

class StructTests: XCTestCase {

    static let allTests = [
        ("testBridgeOptions", testBridgeOptions)
    ]

    func testBridgeOptions() throws {
        // Test initializer
        let t = StorjBridgeOptions(proto: .http, host: "https://test.com", port: 1212, user: "test", pass: "blabla")
        XCTAssertEqual(t.host, "https://test.com")
        XCTAssertEqual(t.proto, .http)
        XCTAssertEqual(t.port, 1212)
        XCTAssertEqual(t.user, "test")
        XCTAssertEqual(t.pass, "blabla")

        t.host = "https://test.xyz"
        XCTAssertEqual(t.host, "https://test.xyz")

        t.proto = .https
        XCTAssertEqual(t.proto, .https)

        // Special nil setter should do nothing
        t.proto = nil
        XCTAssertEqual(t.proto, .https)

        t.port = 1234
        XCTAssertEqual(t.port, 1234)

        t.user = "User"
        XCTAssertEqual(t.user, "User")

        t.pass = "PassworD"
        XCTAssertEqual(t.pass, "PassworD")
    }
}
