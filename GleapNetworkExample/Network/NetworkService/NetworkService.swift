//
//  NetworkService.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

protocol NetworkServiceProtocol {
    typealias CompletionHandler<T> = (Result<T, NetworkError>) -> Void
    
    associatedtype EndPoint: EndPointType
    
    var router: NetworkRouterProtocol { get }
    
    @discardableResult
    func fetch(endPoint: EndPoint, completion: @escaping CompletionHandler<Data>) -> Cancellable?
    
    @discardableResult
    func fetchDecodable<T: Decodable>(endPoint: EndPoint, completion: @escaping CompletionHandler<T>) -> Cancellable?
    
}

extension NetworkServiceProtocol {
    
    @discardableResult
    func fetch(endPoint: EndPoint, completion: @escaping CompletionHandler<Data>) -> Cancellable? {
        return router.request(endPoint) { (result) in
            switch result {
            case .success(let response):
                completion(response.response())
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func fetchDecodable<T: Decodable>(
        endPoint: EndPoint,
        completion: @escaping CompletionHandler<T>
    ) -> Cancellable? {
        return router.request(endPoint) { (result) in
            switch result {
            case .success(let response):
                completion(response.responseDecodable(of: T.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
