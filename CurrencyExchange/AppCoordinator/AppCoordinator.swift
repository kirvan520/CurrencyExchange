//
//  AppCoordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow?
    private let navigationcontroller = UINavigationController()
    
    // MARK: Initialization

    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else { return }
        window.rootViewController = navigationcontroller
        window.makeKeyAndVisible()
        
        showItemListView()
    }
    
    private func showItemListView() {
        let coordinator = CurrencySelectionCoordinator(navigationcontroller: self.navigationcontroller)
        store(coordinator: coordinator)
        coordinator.start()
    }
}
