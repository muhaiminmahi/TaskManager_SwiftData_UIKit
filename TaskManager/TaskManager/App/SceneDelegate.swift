//
//  SceneDelegate.swift
//  TaskManager
//
//  Created by Mahi on 30/3/26.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let taskList = TaskListViewController()
        let nav = UINavigationController(rootViewController: taskList)
        nav.navigationBar.prefersLargeTitles = true

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

