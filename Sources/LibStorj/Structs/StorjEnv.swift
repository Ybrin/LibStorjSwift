//
//  StorjEnv.swift
//  LibStorj
//
//  Created by Koray Koska on 06/09/2017.
//
//

import Foundation
import CLibStorj

public class StorjEnv: CStruct {

    public typealias StructType = storj_env_t

    var storjEnv: StructType

    init(type: StructType) {
        storjEnv = type
    }

    public func get() -> StructType {
        return storjEnv
    }

    deinit {
    }
}
