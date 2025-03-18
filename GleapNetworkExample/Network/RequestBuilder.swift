//
//  RequestBuilder.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

protocol RequestBuilderProtocol {
    func buildRequest(from route: EndPointType) throws -> URLRequest
}

class RequestBuilder: RequestBuilderProtocol {
    func buildRequest(from route: EndPointType) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30)

        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                break
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):

                try configureParameters(bodyParameters: bodyParameters,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParameters,
                                        request: &request)

            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                Self.addAdditionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParameters,
                                        request: &request)
                
            case .requestParametersAsArrayAndHeaders(let bodyParameters,
                                                     let bodyEncoding,
                                                     let urlParameters,
                                                     let additionalHeaders):
                Self.addAdditionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            }
            return request
        } catch {
            throw error
        }
    }

    private func configureParameters(bodyParameters: Parameters?,
                                    bodyEncoding: ParameterEncoding,
                                    urlParameters: Parameters?,
                                    request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    body: bodyParameters, url: urlParameters)
        } catch {
            throw error
        }
    }

    private func configureParameters(bodyParameters: [Parameters]?,
                                    bodyEncoding: ParameterEncoding,
                                    urlParameters: Parameters?,
                                    request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    body: bodyParameters, url: urlParameters)
        } catch {
            throw error
        }
    }

    static func addAdditionalHeaders(_ additionalHeaders: [HTTPHeader]?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for header in headers {
            request.setValue(header.value.headerValue,
                             forHTTPHeaderField: header.key)
        }
    }
}

