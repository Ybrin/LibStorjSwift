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

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

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
            let newPointer = strdup(newValue)
            jsonRequest.method = newPointer

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
        }
    }

    public var path: String {
        get {
            return String(cString: jsonRequest.path)
        }
        set {
            let newPointer = strdup(newValue)
            jsonRequest.path = newPointer

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
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
        let methodPointer = strdup(method)
        let pathPointer = strdup(path)

        var h = httpOptions.get()
        var o = options.get()
        let out = StructType(
            http_options: &h,
            options: &o,
            method: methodPointer,
            path: pathPointer,
            auth: auth,
            body: body.jsonObject(),
            response: response.jsonObject(),
            error_code: errorCode,
            status_code: statusCode,
            handle: nil
        )

        self.init(type: out)

        // Add allocated memory pointers to allocated pointers array
        if let methodPointer = methodPointer {
            allocatedPointers.append(methodPointer)
        }
        if let pathPointer = pathPointer {
            allocatedPointers.append(pathPointer)
        }
    }

    init(type: StructType) {
        jsonRequest = type
    }

    public func get() -> StructType {
        return jsonRequest
    }

    deinit {
        for p in allocatedPointers {
            free(p)
        }
    }
}
