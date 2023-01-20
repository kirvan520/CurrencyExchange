//
//  APIProtocol.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation
import Combine

protocol APIProtocol {
    var session: URLSession { get }
    func send<T: Decodable>(request: URLRequest) async throws -> T
}

extension APIProtocol {

    func send<T: Decodable>(request: URLRequest) async throws -> T {
        
        let result: (data: Data, response: URLResponse) = try await self.session.data(for: request)
        
        guard let httpResponse = (result.response as? HTTPURLResponse) else {
            throw APIError.requestFailed(description: "Request failed!")
        }
        
        let statusCode = httpResponse.statusCode
        guard (200..<300) ~= statusCode else {
            throw APIError.serverError(statusCode: statusCode)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: result.data)
            return decodedData
        } catch let error {
            throw APIError.jsonParsingFailure(description: error.localizedDescription)
        }
    }
    
    func sendRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, APIError> {
        return Deferred {
            Future { promise in
                Task {
                    do {
                        let result: T = try await self.send(request: request)
                        promise(.success(result))
                    } catch let error {
                        promise(.failure(error as! APIError))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
