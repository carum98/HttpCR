//
//  NetworkHttpCR.swift
//  HttpCR
//
//  Created by Carlos Eduardo Umaña Acevedo on 19/6/21.
//

import Foundation

protocol NetworkHttpCR {
    var session: URLSession { get }
}

extension NetworkHttpCR {
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, complete:@escaping (Result<T, ApiError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(.failure(.requestFailed(description: error.debugDescription)))
                return
            }
            
            guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                complete(.failure(.responseUnsuccessful(description: "status code = \(httpResponse.statusCode)")))
                return
            }
            
            guard let data = data else {
                complete(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let genericModel = try decoder.decode(T.self, from: data)
                complete(.success(genericModel))
            }catch let error {
                complete(.failure(.jsonConversionFailure(description: error.localizedDescription)))
            }
        }
        return task
    }
    
    func request<T: Decodable>(
        path: String,
        methods: Methods,
        parameters: [String: Any]? = [:],
        type: T.Type,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        var request = URLRequest(url: URL(string: path)!)
        
        switch methods {
            case .GET:
                request.httpMethod = "GET"
            case .DELETE:
                request.httpMethod = "DELETE"
            case .POST:
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let jsonData = try? JSONSerialization.data(withJSONObject: parameters!)
                request.httpBody = jsonData
            case .PUT:
                request.httpMethod = "PUT"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let jsonData = try? JSONSerialization.data(withJSONObject: parameters!)
                request.httpBody = jsonData
        }
        
        let task = decodingTask(with: request, decodingType: T.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
    }
}
