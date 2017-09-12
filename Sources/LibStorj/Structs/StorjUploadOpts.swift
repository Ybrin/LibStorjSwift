//
//  StorjUploadOpts.swift
//  LibStorj
//
//  Created by Koray Koska on 12/09/2017.
//
//

import Foundation
import CLibStorj
import JSON

public class StorjUploadOpts: CStruct {

    public typealias StructType = storj_upload_opts_t

    var uploadOpts: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var prepareFrameLimit: Int32 {
        return uploadOpts.prepare_frame_limit
    }

    init(type: StructType) {
        uploadOpts = type
    }

    public func get() -> StructType {
        return uploadOpts
    }

    deinit {
        for p in allocatedPointers {
            free(p)
        }
    }
}
