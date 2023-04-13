//
//  ImportantTaskTableViewCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

private enum Constants {
	static let titleLabelNumberOfLines: Int = 2
	static let expiredTaskBackgroundColor: UIColor = .red.withAlphaComponent(0.2)
	static let unexpiredTaskBackgroundColor: UIColor = .white
	static let contentVerticalInset: CGFloat = 12
	static let contentHorizontalInset: CGFloat = 16
	static let contentSpace: CGFloat = 12
	static let checkboxImageViewSize: CGFloat = 32
}

final class ImportantTaskTableViewCell: UITableViewCell, IConfigurableTableCell {

	typealias ConfigurationModel = TaskListModel.ViewData.ImportantTask

	// UI
	private lazy var completionСheckboxImageView: UIImageView = {
		let imageView = UIImageView().prepareForAutoLayout()
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	private lazy var titleLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.numberOfLines = Constants.titleLabelNumberOfLines
		return label
	}()
	private lazy var priorityLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.textColor = .darkGray
		return label
	}()
	private lazy var executionDateLabel: UILabel = {
		let label = UILabel().prepareForAutoLayout()
		label.textColor = .darkGray
		return label
	}()

	// Properties
	private var completionCheckboxTapAction: (() -> Void)?

	// MARK: - Initialization

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		setupLayout()
		configureUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func prepareForReuse() {
		super.prepareForReuse()
		completionСheckboxImageView.image = nil
		titleLabel.text = nil
		priorityLabel.text = nil
		executionDateLabel.text = nil
	}

	// MARK: - IConfigurableTableCell

	func configure(with model: ConfigurationModel) {
		completionCheckboxTapAction = model.completionCheckboxTapAction

		titleLabel.text = model.title
		completionСheckboxImageView.image = UIImage(systemName: model.checkboxImageName)
		priorityLabel.text = model.priorityText
		executionDateLabel.text = model.executionDate
		contentView.backgroundColor = model.isExpired ? Constants.expiredTaskBackgroundColor : Constants.unexpiredTaskBackgroundColor
	}

	// MARK: - Private methods

	private func setupUI() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(completionСheckboxImageView)
		contentView.addSubview(priorityLabel)
		contentView.addSubview(executionDateLabel)

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
		tapGestureRecognizer.isEnabled = true
		completionСheckboxImageView.addGestureRecognizer(tapGestureRecognizer)
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			completionСheckboxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			completionСheckboxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentHorizontalInset),
			completionСheckboxImageView.widthAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),
			completionСheckboxImageView.heightAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),

			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentVerticalInset),
			titleLabel.leadingAnchor.constraint(equalTo: completionСheckboxImageView.trailingAnchor, constant: Constants.contentSpace),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset),

			priorityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.contentSpace),
			priorityLabel.leadingAnchor.constraint(equalTo: completionСheckboxImageView.trailingAnchor, constant: Constants.contentSpace),
			priorityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentVerticalInset),

			executionDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.contentSpace),
			executionDateLabel.leadingAnchor.constraint(equalTo: priorityLabel.trailingAnchor, constant: Constants.contentSpace),
			executionDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset),
			executionDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentVerticalInset),
		])
		executionDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
	}

	private func configureUI() {
		selectionStyle = .none
	}

	@objc
	private func didTapCheckbox() {
		completionCheckboxTapAction?()
	}
}
