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

    var t: StructType

    init(type: StructType) {
        t = type
    }

    public func get() -> StructType {
        return t
    }
}
