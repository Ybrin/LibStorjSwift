//
//  StorjLogLevels.swift
//  LibStorj
//
//  Created by Koray Koska on 05/09/2017.
//
//

import Foundation
import CLibStorj

public class StorjLogLevels: CStruct {

    static var loggerMap: [String: StorjSwiftLoggerFormat] = [:]

    public typealias StructType = storj_log_levels_t

    var logOptions: StructType

    /// A handle, aka context for this exact instance
    var handle: String

    public convenience init(loggerFormat: StorjSwiftLoggerFormat? = nil) {
        let handle = UUID().uuidString
        type(of: self).loggerMap[handle] = loggerFormat

        let cLog: (@convention(c) (UnsafeMutablePointer<storj_log_options_t>?, UnsafeMutableRawPointer?, UnsafePointer<Int8>?) -> Void) = { options, handle, format in
            guard let cContext = handle?.assumingMemoryBound(to: Int8.self) else {
                return
            }
            let context = String(cString: cContext)

            // let message = String(cString: msg)
            // StorjLogLevels.loggerMap[context]?(message, Int(level))
        }

        let options = StructType()
        self.init(type: options, handle: handle)
    }

    init(type: StructType, handle: String) {
        logOptions = type
        self.handle = handle
    }

    public func get() -> StructType {
        return logOptions
    }

    deinit {
        // Delete logger for this instance
        type(of: self).loggerMap[handle] = nil
    }
}

public protocol StorjSwiftLoggerFormat {

    func debug(message: String, level: Int) -> String

    func info(message: String, level: Int) -> String

    func warn(message: String, level: Int) -> String

    func error(message: String, level: Int) -> String
}
