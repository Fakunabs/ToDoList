//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	// Properties
	var window: UIWindow?

	// MARK: - Lifecycle

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: windowScene)
		let rootViewController = AuthorizationAssembly().assemble()
		let rootNavigationController = UINavigationController(rootViewController: rootViewController)
		self.window?.rootViewController = rootNavigationController
		self.window?.makeKeyAndVisible()
	}
}
