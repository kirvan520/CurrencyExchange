//
//  Coordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

/*
 Coordinator responsibility is to handle navigation flow
 */

protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

/*
 Store new coordinators to child coordinators stack and remove them when flow is finished.
 */
extension Coordinator {
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
