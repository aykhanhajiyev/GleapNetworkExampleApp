//
//  LoginUserModel.swift
//  GleapNetworkExample
//
//  Created by Aykhan Hajiyev on 18.03.25.
//

import Foundation

struct LoginUserModel {
    struct Request: ParamConvertible {
        let phoneNumber: String
        let password: String
    }
    
    struct Response: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}

protocol ParamConvertible {
    func toParams() -> Parameters
}

extension ParamConvertible {
    func toParams() -> Parameters {
        var params: Parameters = [:]
        
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let propertyName = child.label {
                params[propertyName] = child.value
            }
        }
        
        return params
    }
}
