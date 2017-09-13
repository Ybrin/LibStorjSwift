//
//  TestToolbox.swift
//  LibStorj
//
//  Created by Koray Koska on 13/09/2017.
//
//

import Foundation

class TestToolbox {

    static func createRandomFile(path: String) {
        let byteCount = 4194304
        let charArray = UnsafeMutablePointer<Int8>.allocate(capacity: byteCount)
        let filePointer = fopen("/dev/urandom", "r")

        for i in 0 ..< 25000 {
            fread(charArray, byteCount, 1, filePointer)

            let rand = fopen(path, "a")
            fputs(charArray, rand)
            
        }
    }
}
