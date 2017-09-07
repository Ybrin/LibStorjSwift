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
        ("testGenerateMnemonic", testGenerateMnemonic)
    ]

    var libStorj: LibStorj!

    override func setUp() {
        libStorj = LibStorj()
    }

    func testGenerateMnemonic() throws {
        let mn = libStorj.storjMnemonicGenerate(strength: 128)
        // print(mn)
        XCTAssertNotNil(mn)
    }
}
