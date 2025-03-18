//
//  HTTPHeaders.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 17.03.23.
//

import Foundation

enum HTTPHeader: Equatable {
    
    static func == (lhs: HTTPHeader, rhs: HTTPHeader) -> Bool {
        switch (lhs, rhs) {
        case (.authorization, .authorization),
            (.acceptLanguage, .acceptLanguage),
            (.appVersion, .appVersion),
            (.deviceType, .deviceType),
            (.contentType, .contentType):
            return true
        default:
            return false
        }
    }
    
     enum ContentType: String {
        case json = "application/json; charset=utf-8"
    }
    
    static var defaultHeaders: [HTTPHeader] {
        [
            .authorization,
            .acceptLanguage,
            .appVersion,
            .deviceType,
            .contentType(.json)
        ].filter { !$0.value.originalValue.isEmpty }
    }

    case authorization
    case authorizationRefresh
    case contentType(_ type: ContentType)
    case acceptLanguage
    case appVersion
    case deviceType
    case quizSessionToken(String)
    case custom(key: String, value: HTTPHeaderValue)

    var key: String {
        switch self {
        case .authorization, .authorizationRefresh: return "Authorization"
        case .contentType: return "Content-Type"
        case .acceptLanguage: return "Accept-Language"
        case .appVersion: return "X-App-Version"
        case .deviceType: return "X-Device-Type"
        case .quizSessionToken: return "X-Quiz-Session-Token"
        case .custom(key: let key, value: _): return key
        }
    }

    var value: HTTPHeaderValue {
        //let userDefaultService: UserDefaultsHelperServiceProtocol = Resolver.resolve()
        
        switch self {
        case .authorization:
            let token = ""
            return HTTPHeaderValue(originalValue: token, headerValue: "Bearer \(token)")
        case .authorizationRefresh:
            let refreshToken = ""
            return HTTPHeaderValue(originalValue: refreshToken, headerValue: "Bearer \(refreshToken)")
        case let .contentType(type):
            return HTTPHeaderValue(originalValue: type.rawValue)

        case .acceptLanguage:
            let lang = "az"
            return HTTPHeaderValue(originalValue: lang)
            
        case .appVersion:
            return HTTPHeaderValue(originalValue: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
        case .deviceType:
            return HTTPHeaderValue(originalValue: "IOS")

        case .quizSessionToken(let sessionToken):
            return HTTPHeaderValue(originalValue: sessionToken)
        case .custom(key: _, value: let value):
            return value
        }
    }
}

struct HTTPHeaderValue {
    let originalValue: String
    let headerValue: String

    // If the header value is the same as original value, just assign original to header
    init(originalValue: String,
                headerValue: String? = nil)
    {
        self.originalValue = originalValue
        self.headerValue = headerValue ?? originalValue
    }
}

extension Array where Element == HTTPHeader {
    func dictionary() -> [String: String] {
        reduce(into: [:]) { result, header in
            result[header.key] = header.value.headerValue
        }
    }
}

