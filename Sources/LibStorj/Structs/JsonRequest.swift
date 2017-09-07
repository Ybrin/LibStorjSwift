//
//  JsonRequest.swift
//  LibStorj
//
//  Created by Koray Koska on 06/09/2017.
//
//

import Foundation
import CLibStorj

public class JsonRequest: CStruct {

    public typealias StructType = json_request_t

    var jsonRequest: StructType

    init(type: StructType) {
        jsonRequest = type
    }

    public func get() -> StructType {
        return jsonRequest
    }

    deinit {
        // free(UnsafeMutablePointer(mutating: bridgeOptions.proto))
    }
}
