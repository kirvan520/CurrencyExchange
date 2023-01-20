//
//  CurrencyConversionSuccessViewModel.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation
import Combine
import UIKit

class CurrencyConversionSuccessViewModel: NSObject {
    
    @Published private(set) var successMessage: String = ""
    
    private(set) var showCurrencySelectionScreen = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let inputModel: SuccessScreenInputData
    
    init(_ inputModel: SuccessScreenInputData) {
        self.inputModel = inputModel
        super.init()
        
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        let exchangeRateModel = inputModel.model
        let targetAmountString = "\((inputModel.amountToConvert * exchangeRateModel.conversionRate).amountInStringFormat) \(exchangeRateModel.targetCode)"
        let convertionRateString = "1/\(exchangeRateModel.conversionRate)"
        successMessage = "Great now you have \(targetAmountString) in your account \n Your convertion rate was \(convertionRateString)"
    }
}
