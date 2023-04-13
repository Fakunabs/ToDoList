//
//  AuthorizationViewController.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 22.02.2023.
//

import UIKit

/// Вью экрана авторизации.
protocol IAuthorizationView: AnyObject {
	/// Отображает данные, соответствующие переданной модели.
	func render(viewModel: AuthorizationModel.ViewModel)
}

private enum Constants {
	static let stackViewSpacing: CGFloat = 24
	static let signInButtonCornerRadius: CGFloat = 6
	static let titleLabelText = "Enter your login and password"
	static let loginTextFieldPlaceholder = "Login"
	static let passwordTextFieldPlaceholder = "Password"
	static let signInButtonTitle = "Sign in"
}

/// Вью экрана авторизации.
final class AuthorizationViewController: UIViewController, IAuthorizationView {

	// UI
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView().prepareForAutoLayout()
		stackView.axis = .vertical
		stackView.spacing = Constants.stackViewSpacing
		return stackView
	}()
	private lazy var titleLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.text = Constants.titleLabelText
		return label
	}()
	private lazy var loginTextField: UITextField = {
		let textField = UITextField().prepareForAutoLayout()
		textField.placeholder = Constants.loginTextFieldPlaceholder
		textField.textAlignment = .center
		textField.borderStyle = .roundedRect
		textField.textContentType = .username
		return textField
	}()
	private lazy var passwordTextField: UITextField = {
		let textField = UITextField().prepareForAutoLayout()
		textField.placeholder = Constants.passwordTextFieldPlaceholder
		textField.textAlignment = .center
		textField.borderStyle = .roundedRect
		textField.textContentType = .password
		textField.isSecureTextEntry = true
		return textField
	}()
	private lazy var signInButton: UIButton = {
		let button = UIButton().prepareForAutoLayout()
		button.setTitle(Constants.signInButtonTitle, for: .normal)
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = Constants.signInButtonCornerRadius
		button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
		return button
	}()

	// Properties
	private let interactor: IAuthorizationInteractor
	private let router: IAuthorizationRouter

	// MARK: - Initialization

	init(interactor: IAuthorizationInteractor, router: IAuthorizationRouter) {
		self.interactor = interactor
		self.router = router
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupLayout()
		configureUI()
	}

	// MARK: - IAuthorizationView

	func render(viewModel: AuthorizationModel.ViewModel) {
		switch viewModel.responseResult {
		case .successfulLogin:
			router.navigateToTaskList()
		case .missedСredentials(let alertModel), .invalidСredentials(let alertModel):
			router.navigateToAlert(model: alertModel)
		}
	}

	// MARK: - Private methods

	private func setupUI() {
		view.addSubview(stackView)
		[titleLabel, loginTextField, passwordTextField, signInButton].forEach { stackView.addArrangedSubview($0) }
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}

	private func configureUI() {
		view.backgroundColor = .white
	}

	@objc
	private func didTapSignInButton() {
		guard let login = loginTextField.text,
			  let password = passwordTextField.text else { return }
		let credentials = AuthorizationModel.Credentials(login: login, password: password)
		let request = AuthorizationModel.Login.Request(credentials: credentials)
		interactor.requestLogin(request: request)
	}
}
