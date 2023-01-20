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
    private let inputModel: ConversionScreenInputData
    
    init(navigationcontroller: UINavigationController, inputModel: ConversionScreenInputData) {
        self.navigationcontroller = navigationcontroller
        self.inputModel = inputModel
    }
    
    override func start() {
        let viewModel = CurrencyConversionViewModel(inputModel)
        
        viewModel.showCurrencyConvertionSuccessScreen.sink { [weak self] inputData in
            guard let self = self else { return }
            
            self.showCurrencyConvertionSuccessScreen(inputData)
        }.store(in: &cancellables)
        
        let viewController = CurrencyConversionViewController(viewModel: viewModel)
        self.navigationcontroller.pushViewController(viewController, animated: true)
    }
    
    private func showCurrencyConvertionSuccessScreen(_ inputData: SuccessScreenInputData) {
        let coordinator = CurrencyConversionSuccessCoordinator(navigationcontroller:self.navigationcontroller,
                                                               inputModel: inputData)
        store(coordinator: coordinator)
        coordinator.start()
    }
}
