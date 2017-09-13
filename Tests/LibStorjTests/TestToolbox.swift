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
        let byteCount = 1000
        let charArray = UnsafeMutablePointer<Int8>.allocate(capacity: byteCount)
        let filePointer = fopen("/dev/urandom", "r")

        let rand = fopen(path, "a")

        for _ in 0 ..< 25000 {
            fread(charArray, 1, byteCount, filePointer)

            fputs(charArray, rand)
        }
        fclose(rand)
        fclose(filePointer)
    }

    static func deleteFile(path: String) -> Bool {
        return remove(path) == 0
    }
}
