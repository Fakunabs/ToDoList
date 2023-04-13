//
//  AuthorizationAssembly.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import UIKit

/// Сборщик экрана авторизации.
final class AuthorizationAssembly {

	func assemble() -> UIViewController {
		let presenter = AuthorizationPresenter()
		
		let credentialsVerifier = CredentialsVerifier()
		let interactor = AuthorizationInteractor(
			presenter: presenter,
			credentialsVerifier: credentialsVerifier
		)

		let router = AuthorizationRouter()
		let viewController = AuthorizationViewController(interactor: interactor, router: router)
		
		presenter.view = viewController
		router.viewController = viewController
		return viewController
	}
}
