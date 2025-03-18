//
//  SessionManager.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

protocol SessionManagerProtocol: AnyObject {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    var session: URLSession { get }
    func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask
}


final class SessionManager: NSObject {
    final class Request {
        var data: Data
        var response: URLResponse?
        var error: Error?
        let handler: CompletionHandler?

        init(data: Data,
             response: URLResponse? = nil,
             error: Error? = nil,
             handler: CompletionHandler?) {
            self.data = data
            self.response = response
            self.error = error
            self.handler = handler
        }
    }

    let session: URLSession

    private let sessionDelegate: SessionDelegate

    private let requestMap = RequestMap()

    // MARK: - Init

    convenience init(
        configuration: URLSessionConfiguration,
        delegateQueue: OperationQueue? = nil
    ) {
//        let challengeHandler: NetworkChallangeHandlerProtocol = Resolver.shared.resolve()
//        let delegate = SessionDelegate(
//            challengeHandler: challengeHandler
//        )
        let delegate = SessionDelegate()
        let session = URLSession(
            configuration: configuration,
            delegate: delegate,
            delegateQueue: delegateQueue
        )
        self.init(session: session, delegate: delegate)
    }

    init(session: URLSession, delegate: SessionDelegate) {
        self.session = session
        self.sessionDelegate = delegate
        super.init()
        sessionDelegate.stateProvider = self
    }
}

// MARK: - SessionManagerProtocol

extension SessionManager: SessionManagerProtocol {
    
    func uploadTask(with request: URLRequest, data: Data, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let task = session.uploadTask(with: request, from: data)
        requestMap[task] = Request(data: Data(), response: nil, error: nil, handler: completionHandler)
        return task
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request)
        requestMap[task] = Request(data: Data(), response: nil, error: nil, handler: completionHandler)
        return task
    }
}

// MARK: - SessionStateProvider

extension SessionManager: SessionStateProvider {
    func request(for task: URLSessionTask) -> SessionManager.Request? {
        requestMap[task]
    }

    func didCompleteTask(_ task: URLSessionTask) {
        guard let request = request(for: task) else {
            return
        }
        requestMap[task]?.handler?(
            request.data,
            request.response,
            request.error
        )
        requestMap[task] = nil
    }
}

// MARK: - Request Map

private final class RequestMap {
    private var map: [URLSessionTask: SessionManager.Request] = [:]

    private let lock = NSLock()

    subscript(_ task: URLSessionTask) -> SessionManager.Request? {
        get {
            lock.lock()
            let result = map[task]
            lock.unlock()
            return result
        }
        set {
            lock.lock()
            map[task] = newValue
            lock.unlock()
        }
    }
}
