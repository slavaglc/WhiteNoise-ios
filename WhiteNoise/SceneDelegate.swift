//
//  SceneDelegate.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
       
        StorageManager.shared.increaseRunsCount()
        let runNumber = StorageManager.shared.getRunsCount()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = MyNavigationController(rootViewController: runNumber <= 1 ? WelcomeViewController() : MixViewController())
        window?.makeKeyAndVisible()
        preparePremiumVersion()
        
        
        
        
//        #if DEBUG
//        print("Running debug build.")
//        #endif
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    private func preparePremiumVersion() {
        Task.init {
            PremiumManager.shared.loadProducts()
            guard await PremiumManager.shared.isPremiumExist() else { return }
            Sound.unlockAllSounds()
            PremiumManager.shared.refreshEntities()
        }
    }
}
