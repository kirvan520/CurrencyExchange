//
//  CurrencySelectionCoordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit
import Combine

class CurrencySelectionCoordinator: BaseCoordinator {

    private var cancellables: Set<AnyCancellable> = []
    private let navigationcontroller: UINavigationController
    
    init(navigationcontroller: UINavigationController) {
        self.navigationcontroller = navigationcontroller
    }
    
    override func start() {
        let viewModel = CurrencySelectionViewModel()
        
        viewModel.showCurrencyConverterScreen.sink { [weak self] exchangeRateModel in
            guard let self = self else { return }
            
            self.showCurrencyConverterScreen(exchangeRateModel)
        }.store(in: &cancellables)
        
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        self.navigationcontroller.setViewControllers([viewController], animated: false)
    }
    
    private func showCurrencyConverterScreen(_ model: ExchangeRateModel) {
        let coordinator = CurrencyConversionCoordinator(navigationcontroller: self.navigationcontroller, model: model)
        store(coordinator: coordinator)
        coordinator.start()
    }
}
