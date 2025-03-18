//
//  JSONParameterEncoder.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

protocol JSONParameterEncoderProtocol: ParameterEncoder { }

final class JSONParameterEncoder: JSONParameterEncoderProtocol {
    
   
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            urlRequest.httpBody = jsonAsData
            
            let contentTypeHeader = HTTPHeader.contentType(.json)
            if urlRequest.value(forHTTPHeaderField: contentTypeHeader.key) == nil {
                urlRequest.setValue(contentTypeHeader.value.headerValue,
                                    forHTTPHeaderField: contentTypeHeader.key)
            }
        }catch {
            throw ParameterEncoderError.encodingFailed
        }
    }

    func encode(urlRequest: inout URLRequest, with parameters: [Parameters]) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            urlRequest.httpBody = jsonAsData

            let contentTypeHeader = HTTPHeader.contentType(.json)
            if urlRequest.value(forHTTPHeaderField: contentTypeHeader.key) == nil {
                urlRequest.setValue(contentTypeHeader.value.headerValue,
                                    forHTTPHeaderField: contentTypeHeader.key)
            }
        } catch {
            throw ParameterEncoderError.encodingFailed
        }
    }
}

