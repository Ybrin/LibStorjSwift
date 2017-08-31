//
//  LinuxMain.swift
//  LibStorj
//
//  Created by Koray Koska on 19/06/2017.
//
//

#if os(Linux)

import XCTest
@testable import LibStorj

XCTMain([
    // All Tests
    testCase(AuthorizationTests.allTests),
])

#endif
