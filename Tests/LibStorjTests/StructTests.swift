//
// Created by Koray Koska on 20/06/2017.
//

import XCTest
@testable import LibStorj

class StructTests: XCTestCase {

    static let allTests = [
        ("testBridgeOptions", testBridgeOptions),
        ("testEncryptOptions", testEncryptOptions),
        ("testHttpOptions", testHttpOptions),
        ("testLogOptions", testLogOptions)
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

        // Test null values
        let t2 = StorjBridgeOptions(proto: .https, host: "https://api.storj.io", port: 1234)
        XCTAssertNil(t2.user)
        XCTAssertNil(t2.pass)

        t2.user = nil
        XCTAssertNil(t2.user)
        t2.pass = nil
        XCTAssertNil(t2.pass)
    }

    func testEncryptOptions() throws {
        let t = StorjEncryptOptions(mnemonic: "Ideally this should be a helpful text")
        XCTAssertEqual(t.mnemonic, "Ideally this should be a helpful text")

        t.mnemonic = "Not so helpful"
        XCTAssertEqual(t.mnemonic, "Not so helpful")
    }

    func testHttpOptions() throws {
        let t = StorjHTTPOptions(userAgent: "chrome", proxyUrl: "https://proxy.url", lowSpeedLimit: 100, lowSpeedTime: 50, timeout: 80)
        XCTAssertEqual(t.userAgent, "chrome")
        XCTAssertEqual(t.proxyUrl, "https://proxy.url")
        XCTAssertEqual(t.lowSpeedLimit, 100)
        XCTAssertEqual(t.lowSpeedTime, 50)
        XCTAssertEqual(t.timeout, 80)

        t.userAgent = "mozilla"
        XCTAssertEqual(t.userAgent, "mozilla")

        t.proxyUrl = "http://proxy2.xyz"
        XCTAssertEqual(t.proxyUrl, "http://proxy2.xyz")

        t.lowSpeedLimit = 340
        XCTAssertEqual(t.lowSpeedLimit, 340)

        t.lowSpeedTime = 222
        XCTAssertEqual(t.lowSpeedTime, 222)

        t.timeout = UInt64(UInt32.max) + UInt64(1000)
        XCTAssertEqual(t.timeout, UInt64(UInt32.max) + UInt64(1000))
    }

    func testLogOptions() throws {
        // Saves what would normally be printed by the logger
        var print = ""

        let t = StorjLogOptions(level: 0) { (msg, level) in
            print = "\(level): \(msg)"
        }

        // Sample run the logger function
        t.get().logger("abcdef", 0, UnsafeMutableRawPointer(mutating: t.handle))

        XCTAssertEqual(print, "0: abcdef")

        t.logger = { (msg, level) in
            print = "#lol"
        }

        // Second sample run
        t.get().logger("ghijkl", 1, UnsafeMutableRawPointer(mutating: t.handle))

        XCTAssertEqual(print, "#lol")
    }
}
