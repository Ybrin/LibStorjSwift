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

    let bridgeOptions: StructType

    public var proto: StorjBridgeOptionsProto? {
        return StorjBridgeOptionsProto(rawValue: String(cString: bridgeOptions.proto))
    }

    public var host: String {
        return String(cString: bridgeOptions.host)
    }

    public var port: Int32 {
        return bridgeOptions.port
    }

    public var user: String {
        return String(cString: bridgeOptions.user)
    }

    public var pass: String {
        return String(cString: bridgeOptions.pass)
    }

    public convenience init(proto: StorjBridgeOptionsProto, host: String, port: Int32, user: String, pass: String) {
        let options = StructType(
            proto: proto.rawValue,
            host: host,
            port: port,
            user: user,
            pass: pass
        )
        self.init(type: options)
    }

    public required init(type: StructType) {
        bridgeOptions = type
    }

    public convenience required init(type: UnsafeMutablePointer<StructType>) {
        self.init(type: type.pointee)
    }

    public func get() -> StructType {
        return bridgeOptions
    }
}

public enum StorjBridgeOptionsProto: String {

    case http = "http"
    case https = "https"
}
