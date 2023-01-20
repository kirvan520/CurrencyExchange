//
//  CurrencySelectionCoordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit

class CurrencySelectionCoordinator: BaseCoordinator {

    private let navigationcontroller: UINavigationController
    
    init(navigationcontroller: UINavigationController) {
        self.navigationcontroller = navigationcontroller
    }
    
    override func start() {
        let viewModel = CurrencySelectionViewModel()
        let viewController = CurrencySelectionViewController(viewModel: viewModel)
        self.navigationcontroller.setViewControllers([viewController], animated: false)
    }
}
