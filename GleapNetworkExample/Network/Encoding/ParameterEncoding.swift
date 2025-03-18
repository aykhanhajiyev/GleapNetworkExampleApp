//
//  ParameterEncoding.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    func encode(urlRequest: inout URLRequest, with parameters: [Parameters]) throws
}

extension ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: [Parameters]) throws {}
}

enum ParameterEncoderError : String, Error {
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    func encode(urlRequest: inout URLRequest, body: Parameters?, url: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = url else {
                    return
                }
                let urlEncoder: URLParameterEncoderProtocol = URLParameterEncoder()
                try urlEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = body else {
                    return
                }
                let jsonEncoder: JSONParameterEncoderProtocol = JSONParameterEncoder()
                try jsonEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = body else {
                    return
                }
                guard let urlParameters = url else {
                    return
                }
                let urlEncoder: URLParameterEncoderProtocol = URLParameterEncoder()
                let jsonEncoder: JSONParameterEncoderProtocol = JSONParameterEncoder()
                try urlEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                try jsonEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
                
            }
        } catch {
            throw error
        }
    }
    
    func encode(urlRequest: inout URLRequest, body: [Parameters]?, url: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = url else {
                    return
                }
                let urlEncoder: URLParameterEncoderProtocol = URLParameterEncoder()
                try urlEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = body else {
                    return
                }
                let jsonEncoder: JSONParameterEncoderProtocol = JSONParameterEncoder()
                try jsonEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = body else {
                    return
                }
                guard let urlParameters = url else {
                    return
                }
                let urlEncoder: URLParameterEncoderProtocol = URLParameterEncoder()
                let jsonEncoder: JSONParameterEncoderProtocol = JSONParameterEncoder()
                try urlEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                try jsonEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
