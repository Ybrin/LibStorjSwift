//
//  StorjBridgeOptions.swift
//  LibStorj
//
//  Created by Koray Koska on 30/08/2017.
//
//

import Foundation
import CLibStorj

public class StorjBridgeOptions: CStruct {

    public typealias StructType = storj_bridge_options_t

    var bridgeOptions: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var proto: StorjBridgeOptionsProto? {
        get {
            return StorjBridgeOptionsProto(rawValue: String(cString: bridgeOptions.proto))
        }
        set {
            if let newValue = newValue {
                let newPointer = strdup(newValue.rawValue)
                bridgeOptions.proto = UnsafePointer(newPointer)

                // Add the new memory pointer to the allocated pointers array
                if let newPointer = newPointer {
                    allocatedPointers.append(newPointer)
                }
            }
        }
    }

    public var host: String {
        get {
            return String(cString: bridgeOptions.host)
        }
        set {
            let newPointer = strdup(newValue)
            bridgeOptions.host = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
        }
    }

    public var port: Int32 {
        get {
            return bridgeOptions.port
        }
        set {
            bridgeOptions.port = newValue
        }
    }

    public var user: String? {
        get {
            if let u = bridgeOptions.user {
                return String(cString: u)
            }
            return nil
        }
        set {
            let newPointer = newValue != nil ? strdup(newValue) : nil
            bridgeOptions.user = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
        }
    }

    public var pass: String? {
        get {
            if let p = bridgeOptions.pass {
                return String(cString: p)
            }
            return nil
        }
        set {
            let newPointer = newValue != nil ? strdup(newValue) : nil
            bridgeOptions.pass = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
        }
    }

    public convenience init(proto: StorjBridgeOptionsProto, host: String, port: Int32, user: String? = nil, pass: String? = nil) {
        let protoPointer = strdup(proto.rawValue)
        let hostPointer = strdup(host)
        let userPointer = user != nil ? strdup(user) : nil
        let passPointer = pass != nil ? strdup(pass) : nil

        let options = StructType(
            proto: protoPointer,
            host: hostPointer,
            port: port,
            user: userPointer,
            pass: passPointer
        )
        self.init(type: options)

        // Add allocated memory pointers to allocated pointers array
        if let protoPointer = protoPointer {
            allocatedPointers.append(protoPointer)
        }
        if let hostPointer = hostPointer {
            allocatedPointers.append(hostPointer)
        }
        if let userPointer = userPointer {
            allocatedPointers.append(userPointer)
        }
        if let passPointer = passPointer {
            allocatedPointers.append(passPointer)
        }
    }

    init(type: StructType) {
        bridgeOptions = type
    }

    public func get() -> StructType {
        return bridgeOptions
    }

    deinit {
        /*for p in allocatedPointers {
            free(p)
        }*/
    }
}

public enum StorjBridgeOptionsProto: String {

    case http = "http"
    case https = "https"
}
