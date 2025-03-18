//
//  EndPointType.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 17.03.23.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: [HTTPHeader]? { get }
}

extension EndPointType {
    
    var baseURL: URL {
        
        guard let url = URL(string: "https://test.onsual.com")
        else { fatalError("baseURL could not be configured.") }
        return url
    }
    
}
