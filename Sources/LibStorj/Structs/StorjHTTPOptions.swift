//
// Created by Koray Koska on 31/08/2017.
//

import Foundation
import CLibStorj

public class StorjHTTPOptions: CStruct {

    public typealias StructType = storj_http_options_t

    var httpOptions: StructType

    public var userAgent: String {
        get {
            return String(cString: httpOptions.user_agent)
        }
        set {
            free(UnsafeMutablePointer(mutating: httpOptions.user_agent))
            httpOptions.user_agent = UnsafePointer(strdup(newValue))
        }
    }

    public var proxyUrl: String? {
        get {
            if let p = httpOptions.proxy_url {
                return String(cString: p)
            }
            return nil
        }
        set {
            free(UnsafeMutablePointer(mutating: httpOptions.proxy_url))
            httpOptions.proxy_url = newValue != nil ? UnsafePointer(strdup(newValue)) : nil
        }
    }

    public var lowSpeedLimit: UInt64 {
        get {
            return httpOptions.low_speed_limit
        }
        set {
            httpOptions.low_speed_limit = newValue
        }
    }

    public var lowSpeedTime: UInt64 {
        get {
            return httpOptions.low_speed_time
        }
        set {
            httpOptions.low_speed_time = newValue
        }
    }

    public var timeout: UInt64 {
        get {
            return httpOptions.timeout
        }
        set {
            httpOptions.timeout = newValue
        }
    }

    /// Initializes StorjHTTPOptions with the given parameters
    ///
    /// - parameter userAgent: The user agent
    /// - parameter proxyUrl: The proxy, if any.
    public convenience init(userAgent: String = "libstorj/0.0.1", proxyUrl: String? = nil, lowSpeedLimit: UInt64 = UInt64(STORJ_LOW_SPEED_LIMIT), lowSpeedTime: UInt64 = UInt64(STORJ_LOW_SPEED_TIME), timeout: UInt64 = UInt64(STORJ_HTTP_TIMEOUT)) {
        let options = StructType(
            user_agent: strdup(userAgent),
            proxy_url: proxyUrl != nil ? strdup(proxyUrl) : nil,
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
