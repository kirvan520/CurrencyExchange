//
//  MockExchangeRateService.swift
//  CurrencyExchangeTests
//
//  Created by Kiran on 1/21/23.
//

@testable import CurrencyExchange
import Foundation
import Combine

class MockExchangeRateService: ExchangeRateService {
    
    var getLatestExchangeRateOfCurrencyPairsAPICallCount = 0
    
    override func getSupportedCurrencyCodes() -> AnyPublisher<SupportedCurrencyCodesResponse, APIError> {
        let dataModel: SupportedCurrencyCodesResponse? = JSONDecoder().getModel(jsonString: MockData.supportedCurrenciesMockJSON)
        return Future<SupportedCurrencyCodesResponse, APIError> { promise in
            promise(.success(dataModel!))
        }.eraseToAnyPublisher()
    }
    
    override func getLatestExchangeRateOfCurrencyPairs(baseCurrencyCode: String, targetCurrencyCode: String) -> AnyPublisher<ExchangeRateModel, APIError> {
        getLatestExchangeRateOfCurrencyPairsAPICallCount += 1
        
        let dataModel: ExchangeRateModel? = JSONDecoder().getModel(jsonString: MockData.currencyPairExchangeRateMockJSON)
        return Future<ExchangeRateModel, APIError> { promise in
            promise(.success(dataModel!))
        }.eraseToAnyPublisher()
    }
}

struct MockData {
    static let supportedCurrenciesMockJSON = """
    {
        "name": "Josh",
        "age": 30,
        "supported_codes": [
            ["AED", "UAE Dirham"],
            ["AFN", "Afghan Afghani"],
            ["ALL", "Albanian Lek"],
            ["AMD", "Armenian Dram"],
            ["ANG", "Netherlands Antillian Guilder"],
            ["AOA", "Angolan Kwanza"],
        ]
    }
    """
    
    static let currencyPairExchangeRateMockJSON = """
    {
        "time_last_update_unix": 1674086401,
        "time_last_update_utc": "Thu, 19 Jan 2023 00:00:01 +0000",
        "time_next_update_unix": 1674172801,
        "time_next_update_utc": "Fri, 20 Jan 2023 00:00:01 +0000",
        "base_code": "AED",
        "target_code": "AFN",
        "conversion_rate": 24.5455
    }
    """
}
