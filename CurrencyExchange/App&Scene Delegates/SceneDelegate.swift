//
//  SceneDelegate.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator:AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
    }
}

