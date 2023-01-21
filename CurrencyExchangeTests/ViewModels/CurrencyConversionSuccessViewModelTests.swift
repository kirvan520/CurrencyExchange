//
//  CurrencyConversionSuccessViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Kiran on 1/21/23.
//

import XCTest
@testable import CurrencyExchange
import Combine

final class CurrencyConversionSuccessViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var inputData: SuccessScreenInputData {
        let exchangeRateModel: ExchangeRateModel? = JSONDecoder().getModel(jsonString: MockData.currencyPairExchangeRateMockJSON)
        return SuccessScreenInputData(model: exchangeRateModel!, amountToConvert: 100)
    }
 
    override func setUp() {
        super.setUp()
    }
    
    func testSuccessMessageString() {
        let viewModel = CurrencyConversionSuccessViewModel(inputData)
        
        let expectation = self.expectation(description: "update success message text label")

        let message = "Great now you have 2,454.55 AFN in your account \n Your convertion rate was 1/24.5455"

        viewModel.$successMessage
            .receive(on: DispatchQueue.main)
            .sink { value in
                XCTAssertEqual(value, message)
                expectation.fulfill()
            }.store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
    }
}

