//
//  WebServiceManager.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation

class WebServiceManager: NSObject {

    static let shared = WebServiceManager()

    private override init() {
        super.init()
    }

    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["content-type": "application/json"]
        config.timeoutIntervalForRequest = 60
        config.httpMaximumConnectionsPerHost = 10
        return URLSession(configuration: config)
    }()

    func makeRequest(_ url: URL, success: @escaping ((_ data: Data) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        let request = URLRequest(url: url)
        performRequest(request, success: success, failure: failure)
    }

    private func performRequest(_ request: URLRequest, success: @escaping ((_ data: Data) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.configuration.urlCache = nil
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                failure(error)
            } else if let webServiceError = self.checkStatusCode(data, response: response as? HTTPURLResponse) {
                failure(webServiceError)
            } else {
                success(data ?? Data())
            }
        }
        
        task.resume()
    }

    private func checkStatusCode(_ data: Data?, response: HTTPURLResponse!) -> Error? {
        var error: Error? = .none
        switch response.statusCode {
        case 200...299:
            break
        default:
            let webError = NSError(domain: "", code: response.statusCode, userInfo: [ NSLocalizedDescriptionKey: "An error has occurred"])
            error = webError
        }
        return error
    }
}
