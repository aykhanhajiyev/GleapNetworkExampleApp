//
//  LoginNetworkService.swift
//  GleapNetworkExample
//
//  Created by Aykhan Hajiyev on 18.03.25.
//

import Foundation

protocol LoginNetworkService {
    func login(
        with request: LoginUserModel.Request,
        completion: @escaping (Swift.Result<LoginUserModel.Response, NetworkError>) -> Void
    )
}

class LoginNetworkServiceImpl: LoginNetworkService, NetworkServiceProtocol {
    let router: NetworkRouterProtocol = Router()
    
    typealias EndPoint = LoginEndPointType
    
    func login(with request: LoginUserModel.Request, completion: @escaping (Result<LoginUserModel.Response, NetworkError>) -> Void) {
        fetchDecodable(endPoint: .login(request.toParams()), completion: completion)
    }
}
