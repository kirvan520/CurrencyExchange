//
//  CurrencyConversionViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Kiran on 1/21/23.
//

import XCTest
@testable import CurrencyExchange
import Combine

final class CurrencyConversionViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var inputData: ConversionScreenInputData {
        let exchangeRateModel: ExchangeRateModel? = JSONDecoder().getModel(jsonString: MockData.currencyPairExchangeRateMockJSON)
        return ConversionScreenInputData(model: exchangeRateModel!, amountToConvert: 100)
    }
 
    override func setUp() {
        super.setUp()
    }
    
    func testCheckBaseAndTargetCurrencyLabelsUpdated() {
        let viewModel = CurrencyConversionViewModel(inputData)
        
        let expectation1 = self.expectation(description: "update base currency text label")
        let expectation2 = self.expectation(description: "update target currency text label")

        viewModel.$baseCurrencyLabelText
            .receive(on: DispatchQueue.main)
            .sink { value in
                XCTAssertEqual(value, "100.00 AED")
                expectation1.fulfill()
            }.store(in: &cancellables)
        
        viewModel.$targetCurrencyLabelText
            .receive(on: DispatchQueue.main)
            .sink { value in
                XCTAssertEqual(value, "2,454.55 AFN")
                expectation2.fulfill()
            }.store(in: &cancellables)
    
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testCheckTimeLeftTextUpdating() {
        let viewModel = CurrencyConversionViewModel(inputData)
        
        let expectation1 = self.expectation(description: "update time left text label text")

        viewModel.$timeLeftLabelText
            .receive(on: DispatchQueue.main)
            .sink { value in
                if value == "25 sec left" {
                    expectation1.fulfill()
                }
            }.store(in: &cancellables)
        
        wait(for: [expectation1], timeout: 10)
    }
    
    func testOnTimeOutErrorAlertTriggered() {
        let viewModel = CurrencyConversionViewModel(inputData)
        
        let expectation1 = self.expectation(description: "show time out error alert")

        viewModel.showTimeoutAlert
            .sink {
                expectation1.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation1], timeout: 35)
    }
    
    func testTimerOutAlertActionTriggerSuccessScrenNavigation() {
        let viewModel = CurrencyConversionViewModel(inputData)
        
        let expectation1 = self.expectation(description: "show time out error alert")

        viewModel.showCurrencyConvertionSuccessScreen.sink { [weak self] value in
            guard let self = self else { return }
            XCTAssertEqual(value.model.conversionRate, self.inputData.model.conversionRate)
            XCTAssertEqual(value.model.baseCode, self.inputData.model.baseCode)
            XCTAssertEqual(value.model.targetCode, self.inputData.model.targetCode)
            XCTAssertEqual(value.amountToConvert, self.inputData.amountToConvert)
            expectation1.fulfill()
        }.store(in: &cancellables)
                
        viewModel.handleConvertAction()
        
        wait(for: [expectation1], timeout: 10)
    }
}
