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

    var logOptions: StructType

    var logger: (@convention(c) (UnsafePointer<Int8>?, Int32, UnsafeMutableRawPointer?) -> Void)? {
        get {
            return logOptions.logger
        }
        set {
            logOptions.logger = newValue
        }
    }

    var level: Int32 {
        get {
            return logOptions.level
        }
        set {
            logOptions.level = newValue
        }
    }

    public convenience init(logger: (@convention(c) (UnsafePointer<Int8>?, Int32, UnsafeMutableRawPointer?) -> Void)? = nil, level: Int32) {
        let options = StructType(logger: logger, level: level)
        self.init(type: options)
    }

    init(type: StructType) {
        logOptions = type
    }

    public func get() -> StructType {
        return logOptions
    }
}
