//
//  JsonRequest.swift
//  LibStorj
//
//  Created by Koray Koska on 06/09/2017.
//
//

import Foundation
import CLibStorj
import JSON

public class JsonRequest: CStruct {

    public typealias StructType = json_request_t

    var jsonRequest: StructType

    public var httpOptions: StorjHTTPOptions {
        get {
            return StorjHTTPOptions(type: jsonRequest.http_options.pointee)
        }
        set {
            var h = newValue.get()
            let http = UnsafeMutablePointer<storj_http_options_t>(&h)
            jsonRequest.http_options = http
        }
    }

    public var options: StorjBridgeOptions {
        get {
            return StorjBridgeOptions(type: jsonRequest.options.pointee)
        }
        set {
            var o = newValue.get()
            let options = UnsafeMutablePointer<storj_bridge_options_t>(&o)
            jsonRequest.options = options
        }
    }

    public var method: String {
        get {
            return String(cString: jsonRequest.method)
        }
        set {
            free(UnsafeMutablePointer(mutating: jsonRequest.method))
            jsonRequest.method = strdup(newValue)
        }
    }

    public var path: String {
        get {
            return String(cString: jsonRequest.path)
        }
        set {
            free(UnsafeMutablePointer(mutating: jsonRequest.path))
            jsonRequest.path = strdup(newValue)
        }
    }

    public var auth: Bool {
        get {
            return jsonRequest.auth
        }
        set {
            jsonRequest.auth = newValue
        }
    }

    public var body: JSON? {
        get {
            return JSON(jsonObject: jsonRequest.body)
        }
        set {
            jsonRequest.body = newValue?.jsonObject()
        }
    }

    public var response: JSON? {
        get {
            return JSON(jsonObject: jsonRequest.response)
        }
        set {
            jsonRequest.response = newValue?.jsonObject()
        }
    }

    public var errorCode: Int32 {
        get {
            return jsonRequest.error_code
        }
        set {
            jsonRequest.error_code = newValue
        }
    }

    public var statusCode: Int32 {
        get {
            return jsonRequest.status_code
        }
        set {
            jsonRequest.status_code = newValue
        }
    }

    public convenience init(
        httpOptions: StorjHTTPOptions,
        options: StorjBridgeOptions,
        method: String,
        path: String,
        auth: Bool,
        body: JSON,
        response: JSON,
        errorCode: Int32,
        statusCode: Int32
        ) {
        var h = httpOptions.get()
        var o = options.get()
        let out = StructType(
            http_options: &h,
            options: &o,
            method: strdup(method),
            path: strdup(path),
            auth: auth,
            body: body.jsonObject(),
            response: response.jsonObject(),
            error_code: errorCode,
            status_code: statusCode,
            handle: nil
        )

        self.init(type: out)
    }

    init(type: StructType) {
        jsonRequest = type
    }

    public func get() -> StructType {
        return jsonRequest
    }

    deinit {
        free(UnsafeMutablePointer(mutating: jsonRequest.method))
        free(UnsafeMutablePointer(mutating: jsonRequest.path))
    }
}
