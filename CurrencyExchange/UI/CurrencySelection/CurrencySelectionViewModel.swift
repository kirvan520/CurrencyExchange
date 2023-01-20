//
//  CurrencySelectionViewModel.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation
import Combine

class CurrencySelectionViewModel: NSObject {
    
    @Published private(set) var state: APIState = .isLoading
    @Published private(set) var supportedCurrencyCodes: [[String]] = []
    @Published private(set) var baseCurrency: String?
    @Published private(set) var targetCurrency: String?
    @Published var pickerViewSelectedRow: Int = 0
    @Published var isBaseCurrencySelected: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    private let service: ExchangeRateServiceProtocol
    
    var showCurrencySelectionPickerView = PassthroughSubject<Void, Never>()
    var selectedCurrencyRow: Int = 0
    
    init(service: ExchangeRateServiceProtocol = ExchangeRateService()) {
        self.service = service
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        self.$supportedCurrencyCodes.sink { [weak self] codes in
            guard let self = self else { return }
            
            guard !codes.isEmpty,
                  let firstCode = codes[0].first,
                  let secondCode = codes[1].first else { return }
            self.baseCurrency = firstCode
            self.targetCurrency = secondCode
        }.store(in: &cancellables)
        
        self.$pickerViewSelectedRow.sink { [weak self] selectedRow in
            guard let self = self else { return }
            
            guard !self.supportedCurrencyCodes.isEmpty,
                  let code = self.supportedCurrencyCodes[selectedRow].first else { return }
            if self.isBaseCurrencySelected {
                self.baseCurrency = code
            } else {
                self.targetCurrency = code
            }
        }.store(in: &cancellables)
        
        self.$isBaseCurrencySelected.sink { [weak self] isSelected in
            guard let self = self else { return }
            
            let code =  isSelected ? self.baseCurrency : self.targetCurrency
            self.selectedCurrencyRow = self.supportedCurrencyCodes.firstIndex { $0.first == code } ?? 0
            self.showCurrencySelectionPickerView.send()
        }.store(in: &cancellables)
    }
}


//MARK: API Calls.

extension CurrencySelectionViewModel {
    
    func getSupportedCurrencyCodes() {
        self.state = .isLoading
        service.getSupportedCurrencyCodes()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.state = .isFinished
                        break
                    case .failure(let error):
                        self.state = .failed(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    
                    self.supportedCurrencyCodes = response.codes
                }
            )
            .store(in: &cancellables)
    }
}
