//
//  CurrencyConversionViewModel.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation
import Combine
import UIKit

class CurrencyConversionViewModel: NSObject {
    
    @Published private(set) var baseCurrencyLabelText: String = ""
    @Published private(set) var targetCurrencyLabelText: String = ""
    @Published private(set) var timeLeftLabelText: String = ""
    @Published private(set) var timeLeftLabelColor: UIColor = .black
    
    private(set) var showCurrencyConvertionSuccessScreen = PassthroughSubject<SuccessScreenInputData, Never>()
    private(set) var showTimeoutAlert = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private var timeLeft: TimeInterval = 30
    private let model: ExchangeRateModel
    private let amountToConvert: Double

    init(_ inputModel: ConversionScreenInputData) {
        self.model = inputModel.model
        self.amountToConvert = inputModel.amountToConvert
        super.init()
        
        setupBindings()
        startTimer()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        
        baseCurrencyLabelText = "\(amountToConvert.amountInStringFormat) \(model.baseCode)"
        
        let targetAmount = (amountToConvert * model.conversionRate).amountInStringFormat
        targetCurrencyLabelText = "\(targetAmount) \(model.targetCode)"
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.timeLeftLabelColor = self.timeLeft <= 10 ? .red : .black
            self.timeLeftLabelText = "\(Int(self.timeLeft)) sec left"
            
            if self.timeLeft == 0 {
                timer.invalidate()
                self.showTimeoutAlert.send()
            }
            
            self.timeLeft -= 1
        }
    }
    
    // MARK: Public methods

    func handleConvertAction() {
        let inputData = SuccessScreenInputData(model: self.model,
                                               amountToConvert: self.amountToConvert)
        self.showCurrencyConvertionSuccessScreen.send(inputData)
    }
}
