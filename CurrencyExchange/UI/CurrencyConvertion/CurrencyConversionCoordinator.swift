//
//  CurrencyConversionCoordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit
import Combine

class CurrencyConversionCoordinator: BaseCoordinator {
    
    private var cancellables: Set<AnyCancellable> = []
    private let navigationcontroller: UINavigationController
    private let model: ExchangeRateModel
    
    init(navigationcontroller: UINavigationController, model: ExchangeRateModel) {
        self.navigationcontroller = navigationcontroller
        self.model = model
    }
    
    override func start() {
        let viewModel = CurrencyConversionViewModel(model: self.model)
        
        viewModel.showCurrencyConvertionSuccessScreen.sink { [weak self] exchangeRateModel in
            guard let self = self else { return }
            
            self.showCurrencyConvertionSuccessScreen()
        }.store(in: &cancellables)
        
        let viewController = CurrencyConversionViewController(viewModel: viewModel)
        self.navigationcontroller.pushViewController(viewController, animated: true)
    }
    
    private func showCurrencyConvertionSuccessScreen() {
        
    }
}
