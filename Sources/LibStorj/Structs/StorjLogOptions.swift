//
//  StorjLogOptions.swift
//  LibStorj
//
//  Created by Koray Koska on 31/08/2017.
//
//

import Foundation
import CLibStorj

public class StorjLogOptions: CStruct {

    public typealias StructType = storj_log_options_t

    public typealias StorjLogger = (_ message: String, _ level: Int) -> Void

    let logOptions: StructType

    var logger: StorjLogger?

    public convenience init(logger: StorjLogger? = nil, level: Int32) {
        let options = StructType(logger: structLogger, level: level)
        self.init(type: options)
    }

    var structLogger: (@convention(c) (UnsafePointer<Int8>?, Int32, UnsafeMutableRawPointer?) -> Void) {
        let c: (@convention(c) (UnsafePointer<Int8>?, Int32, UnsafeMutableRawPointer?) -> Void) = { message, level, handle in
            if let message = message {
                let str = String(cString: message)
                self.logger?(str, Int(level))
            }
        }
        return c
    }

    init(type: StructType) {
        logOptions = type
    }

    public func get() -> StructType {
        return logOptions
    }
}
