//
//  SceneDelegate.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
////
////        let dataManager = CoreDataStack.shared
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let viewController = storyboard.instantiateViewController(
////            identifier: "MapViewController",
////            creator: { coder in
////                return MapViewController(coder: coder, dataManager: dataManager)
////            })
////
//        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
//        let viewController = storyboard.instantiateViewController(identifier: "SplashViewController")
//        
//        window?.rootViewController = viewController
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.save(successHandler: nil)
    }
    
}
