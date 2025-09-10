//
//  APIConfigurationTests.swift
//  BrixieTests
//
//  Tests for API configuration and key injection
//

import Testing
@testable import Brixie

struct APIConfigurationTests {
    
    @Test func apiKeyIsConfigured() async throws {
        // Test that API key is available and not empty
        #expect(!APIConfiguration.rebrickableAPIKey.isEmpty)
    }
    
    @Test func baseURLIsValid() async throws {
        // Test that base URL is valid
        #expect(APIConfiguration.baseURL == "https://rebrickable.com/api/v3")
    }
    
    @Test func apiConfigurationValidationSucceeds() async throws {
        // Test that validation doesn't throw an error
        #expect(throws: Never.self) {
            APIConfiguration.validateConfiguration()
        }
    }
}