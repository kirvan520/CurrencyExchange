//
//  JSONDecoder+Extension.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

extension JSONDecoder {
    func getModel<T: Decodable>(jsonString: String) -> T? {
        let data = Data(jsonString.utf8)
        return try? self.decode(T.self, from: data)
    }
}
