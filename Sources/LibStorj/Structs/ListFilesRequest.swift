//
//  ListFilesRequest.swift
//  LibStorj
//
//  Created by Koray Koska on 11/09/2017.
//
//

import Foundation
import CLibStorj
import JSON

public class ListFilesRequest: CStruct {

    public typealias StructType = list_files_request_t

    var jsonRequest: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var httpOptions: StorjHTTPOptions {
        return StorjHTTPOptions(type: jsonRequest.http_options.pointee)
    }

    public var encryptOptions: StorjEncryptOptions {
        return StorjEncryptOptions(type: jsonRequest.encrypt_options.pointee)
    }

    public var bridgeOptions: StorjBridgeOptions {
        return StorjBridgeOptions(type: jsonRequest.options.pointee)
    }

    public var bucketId: String {
        return String(cString: jsonRequest.bucket_id)
    }

    public var method: String {
        return String(cString: jsonRequest.method)
    }

    public var path: String {
        return String(cString: jsonRequest.path)
    }

    public var auth: Bool {
        return jsonRequest.auth
    }

    public var response: JSON? {
        return JSON(jsonObject: jsonRequest.response)
    }

    public var body: JSON? {
        return JSON(jsonObject: jsonRequest.body)
    }

    public var files: [StorjFileMeta] {
        var fs = [StorjFileMeta]()

        let count = totalFiles
        for i: UInt32 in 0 ..< count {
            let p = jsonRequest.files + Int(i)
            fs.append(StorjFileMeta(type: p.pointee))
        }

        return fs
    }

    public var totalFiles: UInt32 {
        return jsonRequest.total_files
    }

    public var errorCode: Int32 {
        return jsonRequest.error_code
    }

    public var statusCode: Int32 {
        return jsonRequest.status_code
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
