//
//  SceneDelegate.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 10.12.2020.
//

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    var userIsLoggedIn: Bool!
    func scene(_ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        userIsLoggedIn = defaults.bool(forKey: "UserIsLoggedIn")
        let rootVC = userIsLoggedIn ? MainTabBarController() : UINavigationController(rootViewController: LoginController())
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()
    }

}

