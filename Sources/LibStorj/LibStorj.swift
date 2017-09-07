//
//  LibStorj.swift
//  LibStorj
//
//  Created by Koray Koska on 28/08/2017.
//
//

import Foundation
import CLibStorj

public class LibStorj {

    /**
     * Initialize a Storj environment
     *
     * This will setup an event loop for queueing further actions, as well
     * as define necessary configuration options for communicating with Storj
     * bridge, and for encrypting/decrypting files.
     *
     * - parameter options: Storj Bridge API options
     * - parameter encryptOptions: File encryption options
     * - parameter httpOptions: HTTP settings
     * - parameter logOptions: Logging settings
     *
     * - returns: A null value on error, otherwise a storj_env pointer.
     */
    public func storjInitEnv(
        options: StorjBridgeOptions,
        encryptOptions: StorjEncryptOptions,
        httpOptions: StorjHTTPOptions,
        logOptions: StorjLogOptions
        ) -> StorjEnv? {
        var o = options.get()
        var e = encryptOptions.get()
        var h = httpOptions.get()
        var l = logOptions.get()

        guard let r = storj_init_env(&o, &e, &h, &l)?.pointee else {
            return nil
        }

        return StorjEnv(type: r)
    }

    /**
     * Destroy a Storj environment
     *
     * This will free all memory for the Storj environment and zero out any memory
     * with sensitive information, such as passwords and encryption keys.
     *
     * The event loop must be closed before this method should be used.
     *
     * - parameter env: The environment which should be destroyed
     */
    public func storjDestroyEnv(env: StorjEnv) -> Int32 {
        var e = env.get()
        return storj_destroy_env(&e)
    }

    /**
     * Will encrypt and write options to disk
     *
     * This will encrypt bridge and encryption options to disk using a key
     * derivation function on a passphrase.
     *
     * - parameter filepath: The file path to save the options
     * - parameter passphrase: Used to encrypt options to disk
     * - parameter bridgeUser: The bridge username
     * - parameter bridgePass: The bridge password
     * - parameter mnemonic: The file encryption mnemonic
     *
     * - returns: false on error, true on success.
     */
    public func storjEncryptWriteAuth(
        filepath: String,
        passphrase: String,
        bridgeUser: String,
        bridgePass: String,
        mnemonic: String
        ) -> Bool {
        // Duplicate parameters to be unique for this method call
        let path = strdup(filepath)
        let phrase = strdup(passphrase)
        let user = strdup(bridgeUser)
        let pass = strdup(bridgePass)
        let mn = strdup(mnemonic)

        let r = storj_encrypt_write_auth(
            path, phrase,
            user, pass,
            mn
        )

        // Free duplicated parameters
        free(path)
        free(phrase)
        free(user)
        free(pass)
        free(mn)

        return r == 0 ? true : false
    }

    /**
     * Will read and decrypt options from disk
     *
     * This will decrypt bridge and encryption options from disk from
     * the passphrase.
     *
     * - parameter filepath: The file path to read the options
     * - parameter passphrase: Used to encrypt options to disk
     *
     * - returns: Decrypted bridgeUser, bridgePass and mnemonic if successful, nil otherwise
     */
    public func storjDecryptReadAuth(filepath: String, passphrase: String) -> (bridgeUser: String, bridgePass: String, mnemonic: String)? {
        let bridgeUser = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
        let bridgePass = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
        let mnemonic = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)

        // Duplicate parameters to be unique for this method call
        let path = strdup(filepath)
        let phrase = strdup(passphrase)
        guard storj_decrypt_read_auth(path, phrase, bridgeUser, bridgePass, mnemonic) == 0,
            let u = bridgeUser.pointee, let p = bridgePass.pointee, let m = mnemonic.pointee else {
                // Free memory, return nil
                free(path)
                free(phrase)

                bridgeUser.deallocate(capacity: 1)
                bridgePass.deallocate(capacity: 1)
                mnemonic.deallocate(capacity: 1)

                return nil
        }

        // Free duplicated parameters
        free(path)
        free(phrase)

        // Copy buffers into ARC managed memory
        let user = String(cString: u)
        let pass = String(cString: p)
        let mn = String(cString: m)

        // Deallocate allocated buffers
        bridgeUser.deallocate(capacity: 1)
        bridgePass.deallocate(capacity: 1)
        mnemonic.deallocate(capacity: 1)

        return (bridgeUser: user, bridgePass: pass, mnemonic: mn)
    }

    /**
     * Will generate a new random mnemonic
     *
     * This will generate a new random mnemonic with 128 to 256 bits
     * of entropy.
     *
     * - parameter strength: The bits of entropy (128 to 256)
     *
     * - returns: The new mnemonic if successful, nil otherwise
     */
    public func storjMnemonicGenerate(strength: UInt8) -> String? {
        let buffer = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)

        guard storj_mnemonic_generate(Int32(strength), buffer) == 1, let mn = buffer.pointee else {
            // Free memory, return nil
            buffer.deallocate(capacity: 1)

            return nil
        }

        // Copy buffers into ARC managed memory
        let mnemonic = String(cString: mn)

        // Deallocate allocated buffer
        buffer.deallocate(capacity: 1)

        return mnemonic
    }

    /**
     * Will check whether a mnemonic is valid or not
     *
     * This will check whether a mnemonic has been entered correctly by verifying
     * the checksum, and that words are a part of the list.
     *
     * - parameter mnemonic: The mnemonic to check
     *
     * - returns: true on success and false on failure
     */
    public func storjMnemonicCheck(mnemonic: String) -> Bool {
        return storj_mnemonic_check(mnemonic)
    }
}
