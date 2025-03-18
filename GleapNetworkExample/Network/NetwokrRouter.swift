//
//  NetwokrRouter.swift
//  GleapNetworkExample
//
//  Created by Aykhan Hajiyev on 17.03.25.
//

import Foundation
import Gleap

protocol NetworkRouterProtocol: AnyObject {
    typealias CompletionHandler = (Swift.Result<NetworkResponse, NetworkError>) -> Void

    @discardableResult
    func request<EndPoint: EndPointType>(_ route: EndPoint, completion: @escaping CompletionHandler) -> Cancellable?
}

final class Router: NSObject, NetworkRouterProtocol {
    
    private lazy var session: SessionManagerProtocol = {
        let configuration = URLSessionConfiguration.ephemeral
        Gleap.startNetworkRecording(for: configuration)

        return SessionManager(
            configuration: configuration
        )
    }()
    
    private let responseHandler: ResponseHandlerProtocol = ResponseHandler()
    private let requestBuilder: RequestBuilderProtocol = RequestBuilder()
    private let responseQueue = DispatchQueue.main
    
    private var isRefreshingToken = false
    private var pendingRequests: [(EndPointType, CompletionHandler)] = []
    
    override init() {
        super.init()
    }
   
    @discardableResult
    func request<EndPoint: EndPointType>(
        _ route: EndPoint,
        completion: @escaping CompletionHandler
    ) -> Cancellable? {

        var task: URLSessionTask?

        do {
            let request = try requestBuilder.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(
                with: request, completionHandler: { data, response, error in
                    NetworkLogger.log(response: response as? HTTPURLResponse ?? HTTPURLResponse(), bodyData: data)
                    let networkResponse = NetworkResponse(
                        data: data,
                        urlResponse: response,
                        error: error
                    )
                    
                    // Interceptor for handling refresh token
//                    if networkResponse.status == 401 {
//                        print(networkResponse.error as? NetworkError)
//                        self.handleUnauthorized(route, completion: completion)
//                        return
//                    }
                    
                    self.handleResponse(
                        networkResponse,
                        of: route,
                        with: self.responseHandler,
                        urlRequest: request,
                        completion: completion
                    )
                })
        } catch {
            responseQueue.async {
                completion(.failure(NetworkError(type: .badRequest)))
            }
        }
        task?.resume()

        return task
    }
    
    private func handleUnauthorized<EndPoint: EndPointType>(
        _ route: EndPoint,
        completion: @escaping CompletionHandler
    ) {
        pendingRequests.append((route, completion))
        
        guard !isRefreshingToken else { return }
        
        isRefreshingToken = true
        //let refreshTokenManager = RefreshTokenManager.shared
//        refreshTokenManager.refresh { [weak self] in
//            guard let self = self else { return }
//            self.isRefreshingToken = false
//            self.retryPendingRequests()
//        }
    }
    
    private func retryPendingRequests() {
        let requests = pendingRequests
        pendingRequests.removeAll()
        
        for (route, completion) in requests {
            request(route, completion: completion)
        }
    }
    
    private func handleResponse<EndPoint: EndPointType>(
        _ response: NetworkResponse,
        of endPoint: EndPoint,
        with responseHandler: ResponseHandlerProtocol,
        urlRequest: URLRequest,
        completion: @escaping CompletionHandler
    ) {
        switch responseHandler.handleResponse(response) {
        case .success:
            responseQueue.async {
                completion(.success(response))
            }

        case let .failure(networkError):
            responseQueue.async {
                completion(.failure(networkError))
            }
        }
    }
}

