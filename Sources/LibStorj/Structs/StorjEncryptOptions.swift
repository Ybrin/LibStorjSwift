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

    var encryptOptions: StructType

    /// Returns the mnemonic of this StorjEncryptOptions
    public var mnemonic: String {
        get {
            return String(cString: encryptOptions.mnemonic)
        }
        set {
            free(UnsafeMutablePointer(mutating: encryptOptions.mnemonic))
            encryptOptions.mnemonic = UnsafePointer(strdup(newValue))
        }
    }

    /// Initializes StorjEncryptOptions with the given mnemonic
    ///
    /// - parameter mnemonic: The mnemonic is a BIP39 secret code used for generating keys for file
    public convenience init(mnemonic: String) {
        let options = StructType(mnemonic: strdup(mnemonic))
        self.init(type: options)
    }

    init(type: StructType) {
        encryptOptions = type
    }

    public func get() -> StructType {
        return encryptOptions
    }

    deinit {
        free(UnsafeMutablePointer(mutating: encryptOptions.mnemonic))
    }
}
