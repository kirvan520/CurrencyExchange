//
//  BaseCoordinator.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

class BaseCoordinator: NSObject, Coordinator {
  var childCoordinators: [Coordinator] = []
  func start() {}
}
