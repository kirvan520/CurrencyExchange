//
//  APIRequest.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

protocol APIRequest {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: Parameters? { get }
    var parameters: APIRequestParams { get }
    var headers: [String: String]? { get }
}

extension APIRequest {
    
    func request(with baseQueryParameters: Parameters? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: self.baseURL.appendingPathComponent(path))

        switch parameters {
            case .body(let data):
                urlRequest.httpBody = data
            case .url(let params):
                let queryParams = params.map { pair  in
                    return URLQueryItem(name: pair.key, value: "\(pair.value)")
                }
                var components = URLComponents(string: baseURL.appendingPathComponent(path).absoluteString)
                components?.queryItems = queryParams
                urlRequest.url = components?.url
            case .none:
            break
        }
        
        if let url = urlRequest.url {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var items = components?.queryItems ?? []
            
            if let baseQueryParameters = baseQueryParameters {
                let baseQueryItems = baseQueryParameters.map { pair  in
                    return URLQueryItem(name: pair.key, value: "\(pair.value)")
                }
                
                items.append(contentsOf: baseQueryItems)
            }
            
            if let queryParameters = queryParameters {
                let queryItems = queryParameters.map { pair  in
                    return URLQueryItem(name: pair.key, value: "\(pair.value)")
                }
                
                items.append(contentsOf: queryItems)
            }
            
            if items.count > 0 {
                components?.queryItems = items
                urlRequest.url = components?.url
            }
        }
        
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        headers?.forEach({ (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
        
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPHeaderField: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

enum APIRequestParams {
    case body(_ : Data?)
    case url(_: Parameters)
    case none
    
    static func jsonBody<T: Encodable>(from obj: T) -> APIRequestParams {
        return body(try? JSONEncoder().encode(obj))
    }
}
