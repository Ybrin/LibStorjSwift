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
        ("testBuckets", testBuckets)
    ]

    var libStorj: LibStorj!

    override func setUp() {
        let user = "libstorj@trash-mail.com"
        let pass = "libstorj"
        let mnemonic = "punch shed page indicate rival same defense first oppose focus cricket asthma park since liberty menu immune fix item kick palace friend gloom maple"

        let b = StorjBridgeOptions(proto: .https, host: "api.storj.io", port: 443, user: user, pass: pass)
        let e = StorjEncryptOptions(mnemonic: mnemonic)

        libStorj = LibStorj(bridgeOptions: b, encryptOptions: e)

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

    func testBuckets() throws {
        let createBucketSuccess = libStorj.createBucket(name: "storj_bucket") { (success, req) in
            XCTAssertEqual(req.bucketName, "storj_bucket")
            XCTAssert(success)
            XCTAssertEqual(req.statusCode, 201)
        }
        XCTAssert(createBucketSuccess)

        let getBucketsSuccess = libStorj.getBuckets { (success, req) in
            let resp = try? req.response?.serialize().makeString() ?? "***"
            print(req.buckets[0].decrypted)
            print(resp ?? "***")
        }
        XCTAssert(getBucketsSuccess)
    }
}
