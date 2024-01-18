//
//  SceneDelegate.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let viewModel = RobotsViewModel(repo: RobotDataStore(), service: RobotImageService())
        let viewController = RobotsViewController(viewmodel: viewModel)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }

}

