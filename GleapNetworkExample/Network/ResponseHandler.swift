//
//  ResponseHandler.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

protocol ResponseHandlerProtocol: AnyObject {
    func handleResponse(_ networkResponse: NetworkResponse) -> Result<Data, NetworkError>
}

class ResponseHandler: ResponseHandlerProtocol {

    func handleResponse(_ networkResponse: NetworkResponse) -> Result<Data, NetworkError> {
        if let error = networkResponse.error {
            return .failure(handleError(error: error))
        }

        if let response = networkResponse.urlResponse as? HTTPURLResponse {
            let result = self.handleNetworkStatus(response)
            switch result {
            case .success:
                guard let responseData = networkResponse.data else {
                    return .failure(NetworkError(type: .noData))
                }
                return .success(responseData)
            default:
                guard let data = networkResponse.data else {
                    return .failure(NetworkError(type: .noData))
                }
                do {
                    let errorModel = try JSONDecoder().decode(NetworkError.ErrorModel.self, from: data)
                    return .failure(NetworkError(type: result, error: errorModel))
                } catch {
                    return .failure(NetworkError(type: .unableToDecodeError))
                }
            }
        }

        return .failure(NetworkError(type: .noResponse))
    }

    func handleError(error: Error) -> NetworkError {
        guard let nsError = error as NSError? else {
            return NetworkError(type: .unknown)
        }
        
        // TODO: Will be handled
        switch nsError.code {
        case -1_001:
            return NetworkError(
                type: .timedOut,
                error: NetworkError.ErrorModel.init(
                    message: "error_timed_out",
                    detail: ""
                )
            )
            
        case -1_005, -1_009, -1020:
            return NetworkError(
                type: .noNetworkConnection,
                error: NetworkError.ErrorModel.init(
                    message: "error_no_network"
                )
            )
            
        default:
            return NetworkError(
                type: .unknown,
                error: NetworkError.ErrorModel.init(
                    message: "error_unknown"
                )
            )
        }
    }

    func handleNetworkStatus(_ response: HTTPURLResponse) -> NetworkError.ResponseType {
        switch response.statusCode {
        case 200...299, 302: return .success
        case 400: return .badRequest
        case 401: return .authenticationError
        case 403: return .error403
        case 404: return .notFound
        case 406: return .notAcceptable
        case 500...599: return .internalServerError
        case 600: return .outdated
        default: return .failed
        }
    }
}
