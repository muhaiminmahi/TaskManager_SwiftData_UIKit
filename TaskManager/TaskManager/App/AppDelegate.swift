//
//  AppDelegate.swift
//  TaskManager
//
//  Created by Mahi on 30/3/26.
//

import UIKit
import SwiftData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var modelContainer: ModelContainer!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        do {
            modelContainer = try ModelContainer(for: Task.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
 
}

// Handy global accessor — use this in every view controller
func appModelContext() -> ModelContext {
    let app = UIApplication.shared.delegate as! AppDelegate
    return ModelContext(app.modelContainer)
}
