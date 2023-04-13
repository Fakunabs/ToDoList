//
//  AuthorizationPresenter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

/// Презентер экрана авторизации.
protocol IAuthorizationPresenter: AnyObject {
	/// Преподносит вью результат авторизации.
	func presentLogin(response: AuthorizationModel.Login.Response)
}

private enum Constants {
	static let missingСredentialsTitle = "Credentials are missing"
	static let missingСredentialsMessage = "Please enter your login and password."
	static let invalidСredentialsTitle = "Credentials are invalid"
	static let invalidСredentialsMessage = "The entered credentials are invalid.\nPlease enter valid data."
	static let actionTitle = "Ok"
}

/// Презентер экрана авторизации.
final class AuthorizationPresenter: IAuthorizationPresenter {

	// Properties
	weak var view: IAuthorizationView?

	// MARK: - IAuthorizationPresenter

	func presentLogin(response: AuthorizationModel.Login.Response) {
		let viewModel: AuthorizationModel.ViewModel

		switch response.requestResult {
		case .successfulLogin:
			viewModel = AuthorizationModel.ViewModel(responseResult: .successfulLogin)
		case .missedСredentials:
			let alertModel = AuthorizationModel.AlertModel(
				title: Constants.missingСredentialsTitle,
				message: Constants.missingСredentialsMessage,
				actionTitle: Constants.actionTitle
			)
			viewModel = AuthorizationModel.ViewModel(responseResult: .missedСredentials(model: alertModel))
		case .invalidСredentials:
			let alertModel = AuthorizationModel.AlertModel(
				title: Constants.invalidСredentialsTitle,
				message: Constants.invalidСredentialsMessage,
				actionTitle: Constants.actionTitle
			)
			viewModel = AuthorizationModel.ViewModel(responseResult: .invalidСredentials(model: alertModel))
		}

		view?.render(viewModel: viewModel)
	}
}
