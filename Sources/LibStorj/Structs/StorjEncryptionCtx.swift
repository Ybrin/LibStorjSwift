//
//  StorjEncryptionCtx.swift
//  LibStorj
//
//  Created by Koray Koska on 30/08/2017.
//
//

import Foundation
import CLibStorj

public class StorjEncryptionCtx: CStruct {

    public typealias StructType = storj_encryption_ctx_t

    let t: StructType

    public required init(type: StructType) {
        t = type
    }

    public required init(type: UnsafeMutablePointer<StructType>) {
        t = type.pointee
    }

    public func get() -> StructType {
        return t
    }
}
