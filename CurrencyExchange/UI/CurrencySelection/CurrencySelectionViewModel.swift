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
    @Published private(set) var exchangeRateModel: ExchangeRateModel?
    @Published var pickerViewSelectedRow: Int = 0
    @Published var isBaseCurrencySelected: Bool = false
    @Published var amountToConvert: Double = 0.0
    
    private(set) var showCurrencyConverterScreen = PassthroughSubject<ExchangeRateModel, Never>()
    private(set) var showCurrencySelectionPickerView = PassthroughSubject<Int, Never>()
    
    let onAppear = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let service: ExchangeRateServiceProtocol
    
    var isEnableCalcualte: AnyPublisher<Bool, Never> {
        return Publishers
            .CombineLatest3($amountToConvert, $baseCurrency, $targetCurrency)
            .map { amount, baseCurrency, targetCurrency in
                amount > 0 && (baseCurrency != nil) && (targetCurrency != nil)
            }.eraseToAnyPublisher()
    }
    
    var exchangeRateAPIRefreshTimeInterval: Double = 5*60*60 // 5 hours
    
    init(service: ExchangeRateServiceProtocol = ExchangeRateService()) {
        self.service = service
        super.init()
        
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        
        onAppear.sink { [weak self] selectedRow in
            guard let self = self,
                  self.supportedCurrencyCodes.isEmpty else { return }
            
            self.getSupportedCurrencyCodes()
        }
        .store(in: &cancellables)
        
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
            let selectedRow = self.supportedCurrencyCodes.firstIndex { $0.first == code } ?? 0
            self.showCurrencySelectionPickerView.send(selectedRow)
        }.store(in: &cancellables)
        
        self.$exchangeRateModel
            .receive(on: RunLoop.main)
            .sink { [weak self] exchangeRateModel in
                guard let self = self, let model = exchangeRateModel else { return }
                
                self.showCurrencyConverterScreen.send(model)
            }.store(in: &cancellables)
    }
    
    private func saveExchangeRateDataLocally(_ model: ExchangeRateModel) {
        var dataModel = model
        dataModel.timeStamp = Date.currentTimeStamp
        
        do {
            try UserDefaults.standard.save(model: dataModel, forKey: model.baseCode+model.targetCode)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Public methods
    
    func handleCalculateAction() {
        guard let baseCurrency = baseCurrency,
              let targetCurrency = targetCurrency else { return }
        
        //Check local UD if a valid exchange rate data is availabel
        
        let key = baseCurrency+targetCurrency
        
        if let model: ExchangeRateModel = UserDefaults.standard.getModel(forKey: key),
           let timeStamp = model.timeStamp,
           (Date.currentTimeStamp - timeStamp) < exchangeRateAPIRefreshTimeInterval  {
            self.exchangeRateModel = model
        } else {
            getLatestExchangeRateOfCurrencyPairs(baseCurrency, targetCurrency)
        }
    }
}


//MARK: API Calls.

extension CurrencySelectionViewModel {
    
    private func getSupportedCurrencyCodes() {
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
    
    private func getLatestExchangeRateOfCurrencyPairs(_ baseCurrency: String,
                                                      _ targetCurrency: String) {
        
        self.state = .isLoading
        service.getLatestExchangeRateOfCurrencyPairs(baseCurrencyCode: baseCurrency, targetCurrencyCode: targetCurrency)
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
                    
                    self.exchangeRateModel = response
                    self.saveExchangeRateDataLocally(response)
                }
            )
            .store(in: &cancellables)
    }
}
