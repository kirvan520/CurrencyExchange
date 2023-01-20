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
    
    @Published private(set) var timeLeftLabelText: String = ""
    @Published private(set) var timeLeftLabelColor: UIColor = .black
    
    let onAppear = PassthroughSubject<Void, Never>()
    private(set) var showCurrencyConvertionSuccessScreen = PassthroughSubject<Void, Never>()
    private(set) var showTimeoutAlert = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private var timeLeft: TimeInterval = 30
    private let model: ExchangeRateModel
    
    init(model: ExchangeRateModel) {
        self.model = model
        super.init()
        
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        
        onAppear.sink { [weak self] selectedRow in
            guard let self = self else { return }
            
            self.startTimer()
        }
        .store(in: &cancellables)
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
}
