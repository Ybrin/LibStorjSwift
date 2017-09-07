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
        ("testMnemonic", testMnemonic)
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
}
