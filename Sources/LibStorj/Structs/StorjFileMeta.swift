//
//  StorjFileMeta.swift
//  LibStorj
//
//  Created by Koray Koska on 11/09/2017.
//
//

import Foundation
import CLibStorj

public class StorjFileMeta: CStruct {

    public typealias StructType = storj_file_meta_t

    var fileMeta: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var created: String? {
        if fileMeta.created != nil {
            return String(cString: fileMeta.created)
        }
        return nil
    }

    public var filename: String? {
        if fileMeta.filename != nil {
            return String(cString: fileMeta.filename)
        }
        return nil
    }

    public var mimetype: String? {
        if fileMeta.mimetype != nil {
            return String(cString: fileMeta.mimetype)
        }
        return nil
    }

    public var erasure: String? {
        if fileMeta.erasure != nil {
            return String(cString: fileMeta.erasure)
        }
        return nil
    }

    public var size: UInt64 {
        return fileMeta.size
    }

    public var hmac: String? {
        if fileMeta.hmac != nil {
            return String(cString: fileMeta.hmac)
        }
        return nil
    }

    public var id: String? {
        if fileMeta.id != nil {
            return String(cString: fileMeta.id)
        }
        return nil
    }

    public var decrypted: Bool {
        return fileMeta.decrypted
    }

    public var index: String? {
        if fileMeta.index != nil {
            return String(cString: fileMeta.index)
        }
        return nil
    }

    init(type: StructType) {
        fileMeta = type
    }

    public func get() -> StructType {
        return fileMeta
    }

    deinit {
        /*for p in allocatedPointers {
            free(p)
        }*/
    }
}
