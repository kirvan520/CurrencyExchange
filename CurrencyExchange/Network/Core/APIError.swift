//
//  APIError.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

enum APIError: Error {
    case invalidData
    case noInternet
    case serverError(statusCode: Int?)
    case requestFailed(description: String)
    case jsonParsingFailure(description: String)
    case responseUnsuccessful(description: String)
    
    var customDescription: String {
        switch self {
        case .invalidData: return "Invalid data from server"
        case .noInternet: return "No internet connection"
        case let .serverError(statusCode): return "Error with status code \(String(describing: statusCode))"
        case let .requestFailed(description): return "Request Failed error -> \(description)"
        case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
        case let .jsonParsingFailure(description): return "JSON Conversion Failure -> \(description)"
        }
    }
}
