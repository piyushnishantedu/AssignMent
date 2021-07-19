//
//  Environment.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 15/07/21.
//

/**
 Environemnt use to get the base and endpoint for differemnt configuration file
 */
import Foundation
struct Environment {
    static func value(for key: Environment.Key) throws -> String {
        guard let configuration = Bundle.main.object(forInfoDictionaryKey: Key.configuration.rawValue) as? [String: Any],
              let value = configuration[key.rawValue] as? String else {
            throw Error.missingKey
        }
        return value.replacingOccurrences(of: "\\", with: "")
    }
    
    static let baseUrl = URL(string: (try? value(for: .baseURL)) ?? "") ?? URL(fileURLWithPath: "")
    static let endPoint = URL(string: (try? value(for: .endPoint)) ?? "") ?? URL(fileURLWithPath: "")
}

extension Environment {
    enum Key: String {
        case configuration = "Configuration"
        case baseURL = "BASE_URL"
        case endPoint = "ENDPOINT_URL"
    }
    enum Error: Swift.Error {
        case missingKey
    }
}
