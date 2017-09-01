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

    let logOptions: StructType

    public convenience init(logger: (@escaping @convention(c) (UnsafePointer<Int8>?, Int32, UnsafeMutableRawPointer?) -> Void), level: Int32) {
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
