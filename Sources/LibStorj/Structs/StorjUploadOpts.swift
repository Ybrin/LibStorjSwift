//
//  StorjUploadOpts.swift
//  LibStorj
//
//  Created by Koray Koska on 12/09/2017.
//
//

import Foundation
import CLibStorj

public class StorjUploadOpts: CStruct {

    public typealias StructType = storj_upload_opts_t

    var uploadOpts: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var prepareFrameLimit: Int32 {
        return uploadOpts.prepare_frame_limit
    }

    public var pushFrameLimit: Int32 {
        return uploadOpts.push_frame_limit
    }

    public var pushShardLimit: Int32 {
        return uploadOpts.push_shard_limit
    }

    public var rs: Bool {
        return uploadOpts.rs
    }

    public var index: String? {
        if uploadOpts.index != nil {
            return String(cString: uploadOpts.index)
        }
        return nil
    }

    public var bucketId: String? {
        if uploadOpts.bucket_id != nil {
            return String(cString: uploadOpts.bucket_id)
        }
        return nil
    }

    public var fileName: String? {
        if uploadOpts.file_name != nil {
            return String(cString: uploadOpts.file_name)
        }
        return nil
    }

    public var fd: FILE? {
        if uploadOpts.fd != nil {
            return uploadOpts.fd.pointee
        }
        return nil
    }

    /// Initializes StorjUploadOpts with the given parameters
    ///
    public convenience init(
        prepareFrameLimit: Int32,
        pushFrameLimit: Int32,
        pushShardLimit: Int32,
        rs: Bool,
        index: String? = nil,
        bucketId: String,
        fileName: String,
        fd: UnsafeMutablePointer<FILE>
        ) {
        let indexPointer = index != nil ? strdup(index) : nil
        let bucketIdPointer = strdup(bucketId)
        let fileNamePointer = strdup(fileName)

        let options = StructType(
            prepare_frame_limit: prepareFrameLimit,
            push_frame_limit: pushFrameLimit,
            push_shard_limit: pushShardLimit,
            rs: rs,
            index: indexPointer,
            bucket_id: bucketIdPointer,
            file_name: fileNamePointer,
            fd: fd
        )
        self.init(type: options)

        // Add allocated memory pointers to allocated pointers array
        if let indexPointer = indexPointer {
            allocatedPointers.append(indexPointer)
        }
        if let bucketIdPointer = bucketIdPointer {
            allocatedPointers.append(bucketIdPointer)
        }
        if let fileNamePointer = fileNamePointer {
            allocatedPointers.append(fileNamePointer)
        }
    }

    init(type: StructType) {
        uploadOpts = type
    }

    public func get() -> StructType {
        return uploadOpts
    }

    deinit {
        /*for p in allocatedPointers {
            free(p)
        }*/
    }
}
