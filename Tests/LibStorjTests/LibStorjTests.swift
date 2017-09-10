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
        ("testGetInfo", testGetInfo),
        ("testGetBuckets", testGetBuckets)
    ]

    var libStorj: LibStorj!

    override func setUp() {
        let o = LibStorj.decryptReadAuth(filepath: "$PATH", passphrase: "$PASS")

        XCTAssertNotNil(o)

        let b = StorjBridgeOptions(proto: .https, host: "api.storj.io", port: 443, user: o?.bridgeUser, pass: o?.bridgePass)
        let e = StorjEncryptOptions(mnemonic: o!.mnemonic)

        libStorj = LibStorj(options: b, encryptOptions: e)

        XCTAssertNotNil(libStorj)
    }

    func testMnemonic() throws {
        let mn = LibStorj.mnemonicGenerate(strength: 128)
        // print(mn)
        XCTAssertNotNil(mn)

        // Test check mnemonic
        XCTAssert(LibStorj.mnemonicCheck(mnemonic: mn!))

        XCTAssertFalse(LibStorj.mnemonicCheck(mnemonic: "abc def ghi jkl mno pqr stu vwx yz"))
    }

    func testGetInfo() throws {
        let success = libStorj.getInfo() { (success, req) in
            print("PRINTING SUCCESS: \(success)")
            print("SUCCESS!")
            let resp = try? req.response?.serialize().makeString() ?? ""
            // print(resp ?? "***")

            XCTAssertNotNil(resp)
        }

        XCTAssert(success)
    }

    func testGetBuckets() throws {
        let success = libStorj.getBuckets { (success, req) in
            print("PRINTING SUCCESS: \(success)")
            print("SUCCESS!")
            let resp = try? req.response?.serialize().makeString() ?? "***"
            print(req.buckets[0].decrypted)
            print(resp ?? "***")
        }

        XCTAssert(success)
    }
}
