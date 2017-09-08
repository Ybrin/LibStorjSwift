//
//  JsonObject.swift
//  LibStorj
//
//  Created by Koray Koska on 07/09/2017.
//
//

import Foundation
import JSON
import CLibStorj

/**
 * JsonObject extension is a converter which basically wraps json-c around the JSON implementation
 * from vapor. (see: https://github.com/vapor/json)
 *
 * **Please be careful with this implementation!**
 *
 * Currently this wrapper is far away from being fast. It is really just meant for internal use
 * as json objects aren't heavily or intensively used in this library.
 *
 * If you use this implementation outside of the context of this library please understand
 * the following points:
 *
 * - You don't get any support regarding the json-c wrapper
 * - This implementation may at any point have breaking changes
 * - For intensive json serializing and deserializing or heavy
 *   usage this implementation **will** be a bottleneck!
 */
public extension JSON {

    public init?(jsonString: String) {
        try? self.init(json: JSON(bytes: jsonString.bytes))
    }

    init?(jsonObject: OpaquePointer) {
        guard let str = json_object_to_json_string(jsonObject) else {
            return nil
        }

        self.init(jsonString: String(cString: str))
    }

    func jsonObject() -> OpaquePointer? {
        guard let s = try? serialize().makeString() else {
            return nil
        }

        return json_tokener_parse(s)
    }
}
