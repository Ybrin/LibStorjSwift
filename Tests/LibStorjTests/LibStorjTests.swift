//
//  LibStorjTests.swift
//  LibStorj
//
//  Created by Koray Koska on 07/09/2017.
//
//

import XCTest
@testable import LibStorj

class LibStorjTests: XCTestCase {

    static let allTests = [
        ("testMnemonic", testMnemonic),
        ("testGetInfo", testGetInfo)
    ]

    var libStorj: LibStorj!

    override func setUp() {
        libStorj = LibStorj()
    }

    func testMnemonic() throws {
        let mn = libStorj.storjMnemonicGenerate(strength: 128)
        // print(mn)
        XCTAssertNotNil(mn)

        // Test check mnemonic
        XCTAssert(libStorj.storjMnemonicCheck(mnemonic: mn!))

        XCTAssertFalse(libStorj.storjMnemonicCheck(mnemonic: "abc def ghi jkl mno pqr stu vwx yz"))
    }

    func testGetInfo() throws {
        let b = StorjBridgeOptions(proto: .https, host: "api.storj.io", port: 443)

        let env = libStorj.storjInitEnv(options: b)

        XCTAssertNotNil(env)

        libStorj.storjBridgeGetInfo(env: env!) { (success, req) in
            print("PRINTING SUCCESS: \(success)")
            print("SUCCESS!")
            let resp = try? req.response?.serialize().makeString() ?? "***"
            print(resp ?? "***")
        }

        print(env!.get().loop.pointee.active_handles)
    }
}
