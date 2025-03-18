//
//  NetworkLogger.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 17.03.23.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        print("\n - - - - - - - - - - OUTGOING - Mode: Test environment - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }

        debugPrint("< - - - - - - - - - - Request Start - - - - - - - - - - >")
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"

        var output: [NSString] = []
        output.append(urlAsString as NSString)
        output.append(method as NSString)
        output.append("\(path)?\(query)" as NSString)

        output.append("< - - - - - - - - Request Headers Start - - - - - - - - >" as NSString)
        request.allHTTPHeaderFields?.forEach({
            output.append("\($0): \($1)" as NSString)
        })
        output.append("< - - - - - - - - Request Headers End - - - - - - - - >" as NSString)

        if let body = request.httpBody,
            let bodyString = String(data: body, encoding: .utf8),
            bodyString.count < 100_000 {
            output.append("< - - - - - - - - Request Body Start - - - - - - - - >" as NSString)
            output.append(bodyString as NSString)
            output.append("< - - - - - - - - Request Body End - - - - - - - - >" as NSString)
        }

        output.forEach({ debugPrint($0) })
        debugPrint("< - - - - - - - - - - Request End - - - - - - - - - - >")
    }
    
    static func log(response: URLResponse, bodyData: Data?) {
        debugPrint("< - - - - - - - - - - Response Start - - - - - - - - - - >")
        if let bodyData = bodyData,
            let bodyString = String(data: bodyData, encoding: .utf8),
            bodyString.count < 100_000 {
            debugPrint(bodyString as NSString)
        }
        debugPrint("< - - - - - - - - - - Response End - - - - - - - - - - >")
    }
}
