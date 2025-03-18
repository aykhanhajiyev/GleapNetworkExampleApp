//
//  LoginEndPointType.swift
//  GleapNetworkExample
//
//  Created by Aykhan Hajiyev on 18.03.25.
//

import Foundation

enum LoginEndPointType {
    case login(Parameters)
}

extension LoginEndPointType: EndPointType {
    var path: String {
        switch self {
        case .login:
            return "/api/customer-management-ms/v1/customer/login"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let params):
            return .requestParametersAndHeaders(
                bodyParameters: params,
                bodyEncoding: .jsonEncoding,
                urlParameters: nil,
                additionHeaders: self.headers
            )
        }
    }
    
    var headers: [HTTPHeader]? {
        switch self {
        case .login:
            return HTTPHeader.defaultHeaders
        }
    }
}
