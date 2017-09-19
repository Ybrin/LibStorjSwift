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

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    /// Returns the mnemonic of this StorjEncryptOptions
    public var mnemonic: String {
        get {
            return String(cString: encryptOptions.mnemonic)
        }
        set {
            let newPointer = strdup(newValue)
            encryptOptions.mnemonic = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
        }
    }

    /// Initializes StorjEncryptOptions with the given mnemonic
    ///
    /// - parameter mnemonic: The mnemonic is a BIP39 secret code used for generating keys for file
    public convenience init(mnemonic: String) {
        let mnemonicPointer = strdup(mnemonic)
        let options = StructType(mnemonic: mnemonicPointer)
        self.init(type: options)

        // Add allocated memory pointers to allocated pointers array
        if let mnemonicPointer = mnemonicPointer {
            allocatedPointers.append(mnemonicPointer)
        }
    }

    init(type: StructType) {
        encryptOptions = type
    }

    public func get() -> StructType {
        return encryptOptions
    }

    deinit {
        /*for p in allocatedPointers {
            free(p)
        }*/
    }
}
