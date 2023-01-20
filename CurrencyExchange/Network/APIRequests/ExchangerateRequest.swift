//
//  ExchangerateRequest.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

enum ExchangerateRequest: APIRequest {
    
    case getSupportedCurrencyCodes
    case getLatestExchangeRateOfCurrencyPairs(_ base: String, _ target: String)
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://v6.exchangerate-api.com/v6/a82bf2fc08dc8b9970920f6b")!
        }
    }
    
    var path: String {
        switch self {
        case .getSupportedCurrencyCodes: return "codes"
        case .getLatestExchangeRateOfCurrencyPairs(let base, let target):
            return "pair/\(base)/\(target)"
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: APIRequestParams {
        return .none
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
}
