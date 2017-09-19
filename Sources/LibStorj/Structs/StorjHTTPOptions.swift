//
// Created by Koray Koska on 31/08/2017.
//

import Foundation
import CLibStorj

public class StorjHTTPOptions: CStruct {

    public typealias StructType = storj_http_options_t

    var httpOptions: StructType

    /// Saves a list of allocated memory pointers which must be freed before
    /// deinitializing this instance
    var allocatedPointers: [UnsafeMutableRawPointer] = []

    public var userAgent: String {
        get {
            return String(cString: httpOptions.user_agent)
        }
        set {
            let newPointer = strdup(newValue)
            httpOptions.user_agent = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
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
            let newPointer = newValue != nil ? strdup(newValue) : nil
            httpOptions.proxy_url = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
        }
    }

    public var cainfoPath: String? {
        get {
            if let c = httpOptions.cainfo_path {
                return String(cString: c)
            }
            return nil
        }
        set {
            let newPointer = newValue != nil ? strdup(newValue) : nil
            httpOptions.cainfo_path = UnsafePointer(newPointer)

            // Add the new memory pointer to the allocated pointers array
            if let newPointer = newPointer {
                allocatedPointers.append(newPointer)
            }
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
    public convenience init(userAgent: String = "libstorj/0.0.1", proxyUrl: String? = nil, cainfoPath: String? = nil, lowSpeedLimit: UInt64 = UInt64(STORJ_LOW_SPEED_LIMIT), lowSpeedTime: UInt64 = UInt64(STORJ_LOW_SPEED_TIME), timeout: UInt64 = UInt64(STORJ_HTTP_TIMEOUT)) {
        let userAgentPointer = strdup(userAgent)
        let proxyUrlPointer = proxyUrl != nil ? strdup(proxyUrl) : nil
        let cainfoPathPointer = cainfoPath != nil ? strdup(cainfoPath) : nil

        let options = StructType(
            user_agent: userAgentPointer,
            proxy_url: proxyUrlPointer,
            cainfo_path: cainfoPathPointer,
            low_speed_limit: lowSpeedLimit,
            low_speed_time: lowSpeedTime,
            timeout: timeout
        )
        self.init(type: options)

        // Add allocated memory pointers to allocated pointers array
        if let userAgentPointer = userAgentPointer {
            allocatedPointers.append(userAgentPointer)
        }
        if let proxyUrlPointer = proxyUrlPointer {
            allocatedPointers.append(proxyUrlPointer)
        }
        if let cainfoPathPointer = cainfoPathPointer {
            allocatedPointers.append(cainfoPathPointer)
        }
    }

    init(type: StructType) {
        httpOptions = type
    }

    public func get() -> StructType {
        return httpOptions
    }

    deinit {
        /*for p in allocatedPointers {
            free(p)
        }*/
    }
}
