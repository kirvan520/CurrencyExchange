//
//  ExchangeRateModel.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

struct ExchangeRateModel: Codable {
    let baseCode: String
    let targetCode: String
    let conversionRate: Double
    var timeStamp: TimeInterval? // Locally saved time stamp

    private enum CodingKeys: String, CodingKey {
        case timeStamp
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
    }
}
