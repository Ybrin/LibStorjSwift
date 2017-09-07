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

    static var loggerMap: [String: StorjSwiftLogger] = [:]

    public typealias StorjSwiftLogger = ((_ message: String, _ level: Int) -> Void)

    public typealias StructType = storj_log_options_t

    var logOptions: StructType

    /// A handle, aka context for this exact instance
    var handle: String

    var logger: StorjSwiftLogger? {
        get {
            return type(of: self).loggerMap[handle]
        }
        set {
            type(of: self).loggerMap[handle] = newValue
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

    public convenience init(level: Int32, logger: StorjSwiftLogger? = nil) {
        let handle = UUID().uuidString
        type(of: self).loggerMap[handle] = logger

        let cLog: (@convention(c) (UnsafePointer<Int8>?, Int32, UnsafeMutableRawPointer?) -> Void) = { msg, level, handle in
            guard let cContext = handle?.assumingMemoryBound(to: Int8.self), let msg = msg else {
                return
            }
            let context = String(cString: cContext)

            let message = String(cString: msg)
            StorjLogOptions.loggerMap[context]?(message, Int(level))
        }

        let options = StructType(logger: cLog, level: level)
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
