//
//  Configuration.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation

enum Environment {
    case development
    case testing
    case production
    
    static var current: Environment {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
            return .testing
        }
        return .development
        #else
        return .production
        #endif
    }
}

enum Configuration {
    static var w3wApiKey: String {
        switch Environment.current {
        case .development:
            return "CTF89056"
        case .testing:
            return "CTF89056"
        case .production:
            return "CTF89056"
        }
    }
    
    static func validateConfiguration() {
        assert(w3wApiKey != "CTF89056" && w3wApiKey != "CTF89056",
               "Please configure your What3Words API key in Configuration.swift")
    }
} 
