//
//  SessionDelegate.swift
//  Onsual
//
//  Created by Aykhan Hajiyev on 23.03.23.
//

import Foundation

protocol SessionStateProvider: AnyObject {
    func request(for task: URLSessionTask) -> SessionManager.Request?
    func didCompleteTask(_ task: URLSessionTask)
}

final class SessionDelegate: NSObject {
    weak var stateProvider: SessionStateProvider?
    
    //private let challengeHandler: NetworkChallangeHandlerProtocol
    
//    init(challengeHandler: NetworkChallangeHandlerProtocol) {
//        self.challengeHandler = challengeHandler
//        super.init()
//    }
}

// MARK: - Session Delegate

//extension SessionDelegate: URLSessionDelegate {
//    
//    func urlSession(
//        _ session: URLSession,
//        didReceive challenge: URLAuthenticationChallenge,
//        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
//    ) {
//        let result = challengeHandler.evaluate(challenge: challenge)
//        completionHandler(result.disposition, result.credential)
//    }
//}

// MARK: - Session Task Delegate

extension SessionDelegate: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let request = stateProvider?.request(for: dataTask) else {
            return
        }
        request.data.append(data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        stateProvider?.request(for: dataTask)?.response = response
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        stateProvider?.request(for: task)?.error = error
        stateProvider?.didCompleteTask(task)
    }
}
