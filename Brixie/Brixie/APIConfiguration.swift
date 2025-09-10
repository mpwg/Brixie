//
//  APIConfiguration.swift
//  Brixie
//
//  API key configuration for Rebrickable API access
//

import Foundation

struct APIConfiguration {
    static let rebrickableAPIKey: String = {
        #if DEBUG
        // In debug builds, try to get from environment or use placeholder
        if let key = ProcessInfo.processInfo.environment["REBRICKABLE_API_KEY"], !key.isEmpty {
            return key
        } else {
            fatalError("REBRICKABLE_API_KEY environment variable is required for debug builds. Set it with: export REBRICKABLE_API_KEY=\"your_key_here\"")
        }
        #else
        // In release builds, use the compile-time injected key
        return REBRICKABLE_API_KEY_INJECTED
        #endif
    }()
    
    static let baseURL = "https://rebrickable.com/api/v3"
    
    static func validateConfiguration() {
        guard !rebrickableAPIKey.isEmpty else {
            fatalError("Rebrickable API key is required but not configured")
        }
    }
}
