//
//  CreateBucketRequest.swift
//  LibStorj
//
//  Created by Koray Koska on 11/09/2017.
//
//

import Foundation
import CLibStorj
import JSON

public class CreateBucketRequest: CStruct {

    public typealias StructType = create_bucket_request_t

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
        return StorjBridgeOptions(type: jsonRequest.bridge_options.pointee)
    }

    public var bucketName: String {
        return String(cString: jsonRequest.bucket_name)
    }

    public var encryptedBucketName: String {
        return String(cString: jsonRequest.encrypted_bucket_name)
    }

    public var response: JSON? {
        return JSON(jsonObject: jsonRequest.response)
    }

    public var bucket: StorjBucketMeta {
        return StorjBucketMeta(type: jsonRequest.bucket.pointee)
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
