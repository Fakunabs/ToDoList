//
//  AuthorizationRouter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import UIKit

/// Роутер экрана авторизации.
protocol IAuthorizationRouter: AnyObject {
	/// Переходит к списку задач.
	func navigateToTaskList()
	/// Переходит к отображению всплывающего сообщения.
	/// - Parameter model: Модель данных всплывающего сообщения.
	func navigateToAlert(model: AuthorizationModel.AlertModel)
}

/// Роутер экрана авторизации.
final class AuthorizationRouter: IAuthorizationRouter {

	// Properties
	weak var viewController: UIViewController?

	// MARK: - IAuthorizationRouter

	func navigateToTaskList() {
		let taskListViewController = TaskListAssembly().assemble()
		taskListViewController.navigationItem.hidesBackButton = true
		viewController?.show(taskListViewController, sender: self)
	}

	func navigateToAlert(model: AuthorizationModel.AlertModel) {
		let credentialsErrorAlertController = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)
		let alertAction = UIAlertAction(title: model.actionTitle, style: .default)
		credentialsErrorAlertController.addAction(alertAction)
		viewController?.present(credentialsErrorAlertController, animated: true)
	}
}
