//
//  StorjBucketMeta.swift
//  LibStorj
//
//  Created by Koray Koska on 10/09/2017.
//
//

import Foundation
import CLibStorj
import JSON

public class StorjBucketMeta: CStruct {

    public typealias StructType = storj_bucket_meta_t

    var bucketMeta: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var created: String {
        return String(cString: bucketMeta.created)
    }

    public var name: String {
        return String(cString: bucketMeta.name)
    }

    public var id: String {
        return String(cString: bucketMeta.id)
    }

    public var decrypted: Bool {
        return bucketMeta.decrypted
    }

    init(type: StructType) {
        bucketMeta = type
    }

    public func get() -> StructType {
        return bucketMeta
    }

    deinit {
        for p in allocatedPointers {
            free(p)
        }
    }
}
