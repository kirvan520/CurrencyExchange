//
//  CurrencySelectionViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Kiran on 1/20/23.
//

import XCTest
@testable import CurrencyExchange
import Combine

final class CurrencySelectionViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: CurrencySelectionViewModel!
    private var service: MockExchangeRateService!

    override func setUp() {
        super.setUp()
        UserDefaults.resetDefaults()
        service = MockExchangeRateService()
        viewModel = CurrencySelectionViewModel(service: service)
    }
    
    func testInitialViewModelSetup() {
        XCTAssertNil(viewModel.baseCurrency)
        XCTAssertNil(viewModel.targetCurrency)
        XCTAssertNil(viewModel.exchangeRateModel)
        XCTAssertEqual(viewModel.amountToConvert, 0.0)
        XCTAssertEqual(viewModel.pickerViewSelectedRow, 0)
        XCTAssertEqual(viewModel.supportedCurrencyCodes.isEmpty, true)

        viewModel.isEnableCalcualte.sink { isEnableCalcualte in
            XCTAssertFalse(isEnableCalcualte)
        }.store(in: &cancellables)
    }
    
    func testGetSupportedCurrenciesAPISuccess() {
         viewModel.onAppear.send()

        let expectation = self.expectation(description: "GetSupportedCurrencyCodes")
        
        viewModel.$state.sink { state in
            expectation.fulfill()
        }.store(in: &cancellables)
        
    
        // performing our asserts:
        XCTAssertFalse(viewModel.supportedCurrencyCodes.isEmpty)
        XCTAssertEqual(viewModel.supportedCurrencyCodes.count, 6)
        
        viewModel.isEnableCalcualte.sink { isEnableCalcualte in
            XCTAssertFalse(isEnableCalcualte)
        }.store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation
        waitForExpectations(timeout: 10)
    }
    
    func testGetLatestExchangeRateAPISuccess() {
        viewModel.amountToConvert = 100
         viewModel.onAppear.send()
        
        let expectation = self.expectation(description: "GetSupportedCurrencyCodes And GetLatestExchangeRate")
        
        var apiFinishedCount = 0
        viewModel.$state.sink { state in
            apiFinishedCount += 1
            if apiFinishedCount == 1 {
                self.viewModel.handleCalculateAction()
            }
            if apiFinishedCount == 2 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
    
        // performing our asserts:
        XCTAssertFalse(viewModel.supportedCurrencyCodes.isEmpty)
        XCTAssertEqual(viewModel.supportedCurrencyCodes.count, 6)
        
        XCTAssertEqual(viewModel.baseCurrency, viewModel.supportedCurrencyCodes[0].first)
        XCTAssertEqual(viewModel.targetCurrency, viewModel.supportedCurrencyCodes[1].first)
        
        XCTAssertNotNil(viewModel.exchangeRateModel)
        XCTAssertEqual(viewModel.exchangeRateModel?.baseCode, "AED")
        XCTAssertEqual(viewModel.exchangeRateModel?.targetCode, "AFN")
        XCTAssertEqual(viewModel.exchangeRateModel?.conversionRate, 24.5455)
        
        viewModel.isEnableCalcualte.sink { isEnableCalcualte in
            XCTAssertTrue(isEnableCalcualte)
        }.store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation
        waitForExpectations(timeout: 10)
    }
    
    func testSelectedBaseCurrency() {
         viewModel.onAppear.send()

        let expectation = self.expectation(description: "GetSupportedCurrencyCodes")
        
        viewModel.$state.sink { state in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.isBaseCurrencySelected = true

        XCTAssertEqual(viewModel.supportedCurrencyCodes[0].first, viewModel.baseCurrency)

        // Awaiting fulfilment of our expecation
        waitForExpectations(timeout: 10)
    }
    
    func testSelectedTargetCurrency() {
        viewModel.onAppear.send()

        let expectation = self.expectation(description: "GetSupportedCurrencyCodes")
        
        viewModel.$state.sink { state in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.isBaseCurrencySelected = false

        XCTAssertEqual(viewModel.supportedCurrencyCodes[1].first, viewModel.targetCurrency)

        // Awaiting fulfilment of our expecation
        waitForExpectations(timeout: 10)
    }
    
    func testChangeBaseCurrency() {
         viewModel.onAppear.send()

        let expectation = self.expectation(description: "GetSupportedCurrencyCodes")
        
        viewModel.$state.sink { state in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.isBaseCurrencySelected = true
        viewModel.pickerViewSelectedRow = 2

        XCTAssertEqual(viewModel.supportedCurrencyCodes[2].first, viewModel.baseCurrency)

        viewModel.isBaseCurrencySelected = false
        viewModel.pickerViewSelectedRow = 3

        XCTAssertEqual(viewModel.supportedCurrencyCodes[3].first, viewModel.targetCurrency)
        
        // Awaiting fulfilment of our expecation
        waitForExpectations(timeout: 10)
    }
    
    func testExchangeRateAPICallWithRefreshtime() {
        XCTAssertEqual(service.getLatestExchangeRateOfCurrencyPairsAPICallCount, 0)

         viewModel.onAppear.send()
        
        viewModel.handleCalculateAction()
        XCTAssertEqual(service.getLatestExchangeRateOfCurrencyPairsAPICallCount, 1)
        XCTAssertNil(viewModel.exchangeRateModel?.timeStamp)

        viewModel.handleCalculateAction()
        XCTAssertEqual(self.service.getLatestExchangeRateOfCurrencyPairsAPICallCount, 1)
        XCTAssertNotNil(viewModel.exchangeRateModel?.timeStamp)

        viewModel.exchangeRateAPIRefreshTimeInterval = 0
        
        viewModel.handleCalculateAction()
        XCTAssertEqual(self.service.getLatestExchangeRateOfCurrencyPairsAPICallCount, 2)
        XCTAssertNil(viewModel.exchangeRateModel?.timeStamp)
    }
}


