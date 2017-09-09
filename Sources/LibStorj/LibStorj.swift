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
        encryptOptions: StorjEncryptOptions? = nil,
        httpOptions: StorjHTTPOptions = StorjHTTPOptions(),
        logOptions: StorjLogOptions = StorjLogOptions()
        ) -> StorjEnv? {
        var o = options.get()
        var e = encryptOptions?.get()
        var h = httpOptions.get()
        var l = logOptions.get()

        let encr = e != nil ? UnsafeMutablePointer(mutating: &e!) : nil

        guard let r = storj_init_env(&o, encr, &h, &l)?.pointee else {
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

        defer {
            // Make sure everything is deallocated before returning
            // Deallocate allocated buffers
            bridgeUser.deallocate(capacity: 1)
            bridgePass.deallocate(capacity: 1)
            mnemonic.deallocate(capacity: 1)
        }

        // Duplicate parameters to be unique for this method call
        let path = strdup(filepath)
        let phrase = strdup(passphrase)

        defer {
            // Make sure everything is freed up before returning
            // Free duplicated parameters
            free(path)
            free(phrase)
        }

        guard storj_decrypt_read_auth(path, phrase, bridgeUser, bridgePass, mnemonic) == 0,
            let u = bridgeUser.pointee, let p = bridgePass.pointee, let m = mnemonic.pointee else {
                return nil
        }

        // Copy buffers into ARC managed memory
        let user = String(cString: u)
        let pass = String(cString: p)
        let mn = String(cString: m)

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

        defer {
            // Deallocate allocated buffer
            buffer.deallocate(capacity: 1)
        }

        guard storj_mnemonic_generate(Int32(strength), buffer) == 1, let mn = buffer.pointee else {
            return nil
        }

        // Copy buffers into ARC managed memory
        let mnemonic = String(cString: mn)

        return mnemonic
    }

    /**
     * Checks whether a mnemonic is valid or not
     *
     * This function checks whether a mnemonic has been entered correctly by verifying
     * the checksum, and by checking whether words are a part of the list.
     *
     * - parameter mnemonic: The mnemonic to check
     *
     * - returns: true on success and false on failure
     */
    public func storjMnemonicCheck(mnemonic: String) -> Bool {
        return storj_mnemonic_check(mnemonic)
    }

    static var getInfoCallbacks: [String: ((_ success: Bool, _ request: JsonRequest) -> Void)] = [:]
    public func storjBridgeGetInfo(env: StorjEnv, completion: ((_ success: Bool, _ request: JsonRequest) -> Void)? = nil) {
        let uuid = UUID().uuidString
        LibStorj.getInfoCallbacks[uuid] = completion

        let callback: uv_after_work_cb = { request, status in
            print("AT LEASTIOOO***")
            guard let req = request?.pointee.data.assumingMemoryBound(to: json_request_t.self).pointee else {
                // There is really nothing left to do here. We don't have a request structure and therefore don't have
                // the handle we need in order to run the callback...
                return
            }
            let handle = String(cString: req.handle.assumingMemoryBound(to: Int8.self))

            LibStorj.getInfoCallbacks[handle]?(status == 0, JsonRequest(type: req))

            // Delete callback after call
            LibStorj.getInfoCallbacks[handle] = nil

            free(req.handle)
        }

        var e = env.get()
        let dupUUID = strdup(uuid)
        storj_bridge_get_info(&e, UnsafeMutableRawPointer(mutating: dupUUID), callback)

        // Run the uv loop
        env.executeLoop()
    }
}
