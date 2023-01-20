//
//  SupportedCurrencyCodesResponse.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

struct SupportedCurrencyCodesResponse: Decodable {
    let codes: [[String]]
    
    private enum CodingKeys: String, CodingKey {
        case codes = "supported_codes"
    }
}
