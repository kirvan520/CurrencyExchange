//
//  CurrencyConversionSuccessCoordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit
import Combine

class CurrencyConversionSuccessCoordinator: BaseCoordinator {
    
    private var cancellables: Set<AnyCancellable> = []
    private let navigationcontroller: UINavigationController
    private let inputModel: SuccessScreenInputData
    
    init(navigationcontroller: UINavigationController,
         inputModel: SuccessScreenInputData) {
        self.navigationcontroller = navigationcontroller
        self.inputModel = inputModel
    }
    
    override func start() {
        let viewModel = CurrencyConversionSuccessViewModel(inputModel)
        
        viewModel.showCurrencySelectionScreen.sink { [weak self] exchangeRateModel in
            guard let self = self else { return }
            
            self.navigationcontroller.popToRootViewController(animated: true)
        }.store(in: &cancellables)
        
        let viewController = CurrencyConversionSuccessViewController(viewModel: viewModel)
        self.navigationcontroller.pushViewController(viewController, animated: true)
    }
}
