//
//  APIClient.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

class APIClient: APIProtocol {

    let session: URLSession

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    convenience init() {
        self.init(configuration: .default)
    }
}
