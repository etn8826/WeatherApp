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
    
    func performRequest<T: Codable>(_ url: URL, onComplete: @escaping ((Result<T, Error>) -> Void)) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                onComplete(.failure(error))
            } else if let webServiceError = self.checkStatusCode(response: response as? HTTPURLResponse) {
                onComplete(.failure(webServiceError))
            } else {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data ?? Data())
                    onComplete(.success(decodedData))
                }
                catch let error {
                    onComplete(.failure(error))
                }
            }
        }
        
        task.resume()
    }

    private func checkStatusCode(response: HTTPURLResponse?) -> Error? {
        guard let statusCode = response?.statusCode else {
            let webError = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: "An error has occurred"])
            return webError
        }
        var error: Error? = .none
        switch statusCode {
        case 200...299:
            break
        default:
            let webError = NSError(domain: "", code: statusCode, userInfo: [ NSLocalizedDescriptionKey: "An error has occurred"])
            error = webError
        }
        return error
    }
}
