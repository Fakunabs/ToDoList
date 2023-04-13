//
//  AuthorizationModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import Foundation

/// Модель экрана авторизации.
enum AuthorizationModel {

	// MARK: - Use cases

	/// Авторизация пользователя
	enum Login {

		struct Request {
			let credentials: Credentials
		}

		struct Response {

			enum RequestResult {
				case successfulLogin
				case missedСredentials
				case invalidСredentials
			}

			let requestResult: RequestResult
		}
	}

	// MARK: - ViewModel

	/// Модель данных вью.
	struct ViewModel {

		enum ResponseResult {
			case successfulLogin
			case missedСredentials(model: AlertModel)
			case invalidСredentials(model: AlertModel)
		}

		let responseResult: ResponseResult
	}
}

// MARK: - Nested models

extension AuthorizationModel {

	/// Модель учётных данных пользователя.
	struct Credentials {
		let login: String
		let password: String
	}

	/// Модель данных всплывающего сообщения.
	struct AlertModel {
		let title: String
		let message: String
		let actionTitle: String
	}
}
