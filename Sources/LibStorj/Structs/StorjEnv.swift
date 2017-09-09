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

    /**
     * Executes the UV loop on the given mode.
     *
     * All queued jobs for this environment will be executed
     *
     * - parameter mode: The uv_run_mode on which the jobs should be run.
     *                   Defaults to `UV_RUN_DEFAULT`.
     */
    func executeLoop(mode: uv_run_mode = UV_RUN_DEFAULT) {
        uv_run(storjEnv.loop, mode)
    }
}
