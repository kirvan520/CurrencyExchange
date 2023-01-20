//
//  ExchangeRateService.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Combine

protocol ExchangeRateServiceProtocol {
    func getSupportedCurrencyCodes() -> AnyPublisher<SupportedCurrencyCodesResponse, APIError>
    func getLatestExchangeRateOfCurrencyPairs(baseCurrencyCode: String, targetCurrencyCode: String) -> AnyPublisher<ExchangeRateModel, APIError>
}

class ExchangeRateService: ExchangeRateServiceProtocol {
    func getSupportedCurrencyCodes() -> AnyPublisher<SupportedCurrencyCodesResponse, APIError> {
        APIClient().sendRequest(request: ExchangerateRequest.getSupportedCurrencyCodes.request())
    }
    
    func getLatestExchangeRateOfCurrencyPairs(baseCurrencyCode: String, targetCurrencyCode: String) -> AnyPublisher<ExchangeRateModel, APIError> {
        APIClient().sendRequest(request: ExchangerateRequest.getLatestExchangeRateOfCurrencyPairs(baseCurrencyCode, targetCurrencyCode).request())
    }
}
