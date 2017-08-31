//
//  StorjEncryptOptions.swift
//  LibStorj
//
//  Created by Koray Koska on 31/08/2017.
//
//

import Foundation
import CLibStorj

public class StorjEncryptOptions: CStruct {

    public typealias StructType = storj_encrypt_options_t

    let encryptOptions: StructType

    /// Returns the mnemonic of this StorjEncryptOptions
    public var mnemonic: String {
        return String(cString: encryptOptions.mnemonic)
    }

    /// Initializes StorjEncryptOptions with the given mnemonic
    ///
    /// - parameter mnemonic: The mnemonic is a BIP39 secret code used for generating keys for file
    public convenience init(mnemonic: String) {
        let options = StructType(mnemonic: mnemonic)
        self.init(type: options)
    }

    public required init(type: StructType) {
        encryptOptions = type
    }

    public convenience required init(type: UnsafeMutablePointer<StructType>) {
        self.init(type: type.pointee)
    }

    public func get() -> StructType {
        return encryptOptions
    }
}
