//
//  NetworkDataModel.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 17.03.23.
//

import Foundation

struct NetworkDataModel<T: Decodable>: Decodable {
    let data: T?
    let message: String?
}

struct NetworkResponse {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?

    var status: Int? {
        (self.urlResponse as? HTTPURLResponse)?.statusCode
    }

    func response() -> Swift.Result<Data, NetworkError> {
        guard let data = data else {
            return .failure(NetworkError(type: .noData))
        }

        return .success(data)
    }

    func responseJSON() -> Swift.Result<Any, NetworkError> {
        guard let data = data else {
            return .failure(NetworkError(type: .noData))
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return .success(json)
        } catch {
            return .failure(NetworkError(type: .unableToDecodeResponse))
        }
    }

    func decodeResponse<T: Decodable>(of type: T.Type) -> Swift.Result<T, NetworkError> {
        guard let data = data else {
            return .failure(NetworkError(type: .noData))
        }

        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(NetworkError(type: .unableToDecodeResponse))
        }
    }

    func responseDecodable<T: Decodable>(of type: T.Type) -> Swift.Result<T, NetworkError> {
        guard let data = data else {
            return .failure(NetworkError(type: .noData))
        }

        let decoder = JSONDecoder()

        do {
            let dataModel = try decoder.decode(T.self, from: data)
            return .success(dataModel)
        } catch _ {
            do {
                let errorData = try decoder.decode(NetworkError.ErrorModel.self, from: data)
                return .failure(NetworkError(type: .unableToDecodeResponse, error: errorData))
            } catch {
            }
        
            return .failure(NetworkError(type: .unableToDecodeResponse))
        }
    }
    

}

struct NetworkError: Error, Equatable {
    let type: ResponseType
    let error: ErrorModel?
    
    init(type: ResponseType, error: ErrorModel? = nil) {
        self.type = type
        self.error = error
    }
}

extension NetworkError {
    enum ResponseType: Equatable {
        case success
        case authenticationError
        case badRequest
        case internalServerError
        case outdated
        case failed
        case noData
        case noResponse
        case unableToDecodeResponse
        case unableToDecodeError
        case unknown
        case timedOut
        case noNetworkConnection
        case error403
        case notFound
        case notAcceptable
        case transferOtpTimeout
        case noRefreshToken
    }
    
    struct ErrorModel: Decodable, Equatable {
        let status: Int?
        let code: String?
        let message: String?
        let detail: String?
        let timestamp: String?
        let path: String?
        
        init(status: Int? = nil, code: String? = nil, message: String? = nil, detail: String? = nil, timestamp: String? = nil, path: String? = nil) {
            self.status = status
            self.code = code
            self.message = message
            self.detail = detail
            self.timestamp = timestamp
            self.path = path
        }
    }
}
