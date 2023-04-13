//
//  RegularTaskTableViewCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

private enum Constants {
	static let titleLabelNumberOfLines: Int = 2
	static let contentViewHeight: CGFloat = 56
	static let contentHorizontalInset: CGFloat = 16
	static let contentSpace: CGFloat = 12
	static let checkboxImageViewSize: CGFloat = 32
}

final class RegularTaskTableViewCell: UITableViewCell, IConfigurableTableCell {

	typealias ConfigurationModel = TaskListModel.ViewData.RegularTask

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
	}

	// MARK: - IConfigurableTableCell

	func configure(with model: ConfigurationModel) {
		completionCheckboxTapAction = model.completionCheckboxTapAction
		
		titleLabel.text = model.title
		completionСheckboxImageView.image = UIImage(systemName: model.checkboxImageName)
	}

	// MARK: - Private methods

	private func setupUI() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(completionСheckboxImageView)

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
		tapGestureRecognizer.isEnabled = true
		completionСheckboxImageView.addGestureRecognizer(tapGestureRecognizer)
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.contentViewHeight),

			completionСheckboxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			completionСheckboxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentHorizontalInset),
			completionСheckboxImageView.widthAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),
			completionСheckboxImageView.heightAnchor.constraint(equalToConstant: Constants.checkboxImageViewSize),

			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: completionСheckboxImageView.trailingAnchor, constant: Constants.contentSpace),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset)
		])
	}

	private func configureUI() {
		selectionStyle = .none
	}

	@objc
	private func didTapCheckbox() {
		completionCheckboxTapAction?()
	}
}
