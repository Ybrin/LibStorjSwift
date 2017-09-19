//
//  GetBucketsRequest.swift
//  LibStorj
//
//  Created by Koray Koska on 10/09/2017.
//
//

import Foundation
import CLibStorj
import SwiftyJSON

public class GetBucketsRequest: CStruct {

    public typealias StructType = get_buckets_request_t

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

    public var method: String {
        return String(cString: jsonRequest.method)
    }

    public var path: String {
        return String(cString: jsonRequest.path)
    }

    public var auth: Bool {
        return jsonRequest.auth
    }

    public var body: JSON? {
        return JSON(jsonObject: jsonRequest.body)
    }

    public var response: JSON? {
        return JSON(jsonObject: jsonRequest.response)
    }

    public var buckets: [StorjBucketMeta] {
        var bs = [StorjBucketMeta]()

        let count = totalBuckets
        for i: UInt32 in 0 ..< count {
            let p = jsonRequest.buckets + Int(i)
            bs.append(StorjBucketMeta(type: p.pointee))
        }

        return bs
    }

    public var totalBuckets: UInt32 {
        return jsonRequest.total_buckets
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
