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

    public var proto: StorjBridgeOptionsProto? {
        get {
            return StorjBridgeOptionsProto(rawValue: String(cString: bridgeOptions.proto))
        }
        set {
            if let newValue = newValue {
                free(UnsafeMutablePointer(mutating: bridgeOptions.proto))
                bridgeOptions.proto = UnsafePointer(strdup(newValue.rawValue))
            }
        }
    }

    public var host: String {
        get {
            return String(cString: bridgeOptions.host)
        }
        set {
            free(UnsafeMutablePointer(mutating: bridgeOptions.host))
            bridgeOptions.host = UnsafePointer(strdup(newValue))
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

    public var user: String {
        get {
            return String(cString: bridgeOptions.user)
        }
        set {
            free(UnsafeMutablePointer(mutating: bridgeOptions.user))
            bridgeOptions.user = UnsafePointer(strdup(newValue))
        }
    }

    public var pass: String {
        get {
            return String(cString: bridgeOptions.pass)
        }
        set {
            free(UnsafeMutablePointer(mutating: bridgeOptions.pass))
            bridgeOptions.pass = UnsafePointer(strdup(newValue))
        }
    }

    public convenience init(proto: StorjBridgeOptionsProto, host: String, port: Int32, user: String, pass: String) {
        let options = StructType(
            proto: strdup(proto.rawValue),
            host: strdup(host),
            port: port,
            user: strdup(user),
            pass: strdup(pass)
        )
        self.init(type: options)
    }

    init(type: StructType) {
        bridgeOptions = type
    }

    public func get() -> StructType {
        return bridgeOptions
    }

    deinit {
        free(UnsafeMutablePointer(mutating: bridgeOptions.proto))
        free(UnsafeMutablePointer(mutating: bridgeOptions.host))
        free(UnsafeMutablePointer(mutating: bridgeOptions.user))
        free(UnsafeMutablePointer(mutating: bridgeOptions.pass))
    }
}

public enum StorjBridgeOptionsProto: String {

    case http = "http"
    case https = "https"
}
