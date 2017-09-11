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

    public var created: String? {
        if bucketMeta.created != nil {
            return String(cString: bucketMeta.created)
        }
        return nil
    }

    public var name: String? {
        if bucketMeta.name != nil {
            return String(cString: bucketMeta.name)
        }
        return nil
    }

    public var id: String? {
        if bucketMeta.id != nil {
            return String(cString: bucketMeta.id)
        }
        return nil
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
