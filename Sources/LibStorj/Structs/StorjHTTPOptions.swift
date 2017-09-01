//
// Created by Koray Koska on 31/08/2017.
//

import Foundation
import CLibStorj

public class StorjHTTPOptions: CStruct {

    public typealias StructType = storj_http_options_t

    let httpOptions: StructType

    public var userAgent: String {
        return String(cString: httpOptions.user_agent)
    }

    public var proxyUrl: String {
        return String(cString: httpOptions.proxy_url)
    }

    public var lowSpeedLimit: UInt64 {
        return httpOptions.low_speed_limit
    }

    public var lowSpeedTime: UInt64 {
        return httpOptions.low_speed_time
    }

    public var timeout: UInt64 {
        return httpOptions.timeout
    }

    /// Initializes StorjHTTPOptions with the given parameters
    ///
    /// - parameter userAgent: The user agent
    /// - parameter proxyUrl: The proxy, if any.
    public convenience init(userAgent: String, proxyUrl: String, lowSpeedLimit: UInt64, lowSpeedTime: UInt64, timeout: UInt64) {
        let options = StructType(
            user_agent: strdup(userAgent),
            proxy_url: strdup(proxyUrl),
            low_speed_limit: lowSpeedLimit,
            low_speed_time: lowSpeedTime,
            timeout: timeout
        )
        self.init(type: options)
    }

    init(type: StructType) {
        httpOptions = type
    }

    public func get() -> StructType {
        return httpOptions
    }

    deinit {
        free(UnsafeMutablePointer(mutating: httpOptions.user_agent))
        free(UnsafeMutablePointer(mutating: httpOptions.proxy_url))
    }
}
