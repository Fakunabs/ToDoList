//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import UIKit

/// Вью экрана списка задач.
protocol ITaskListView: AnyObject {
	/// Отображает данные, соответствующие переданной модели.
	func render(viewModel: TaskListModel.ViewModel)
}

private enum Constants {
	static let title = "To Do List"
}

/// Вью экрана списка задач.
final class TaskListViewController: UIViewController, ITaskListView {

	// UI
	private lazy var tasksTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped).prepareForAutoLayout()
		tableView.registerCell(type: RegularTaskTableViewCell.self)
		tableView.registerCell(type: ImportantTaskTableViewCell.self)
		tableView.dataSource = self
		return tableView
	}()

	// Properties
	private let interactor: ITaskListInteractor
	private var viewData = TaskListModel.ViewData(sections: [])
	
	// MARK: - Initialization

	init(interactor: ITaskListInteractor) {
		self.interactor = interactor
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
		interactor.requestTaskList()
	}

	// MARK: - ITaskListView

	func render(viewModel: TaskListModel.ViewModel) {
		switch viewModel.responseResult {
		case .updatingTaskList(let viewData):
			self.viewData = viewData
			tasksTableView.reloadData()
		case .updatingTask(let updatingTaskModel):
			viewData = updatingTaskModel.viewData

			tasksTableView.performBatchUpdates({
				tasksTableView.moveRow(at: updatingTaskModel.oldIndexPath, to: updatingTaskModel.newIndexPath)
			}, completion: { [weak self] _ in
				self?.tasksTableView.reloadRows(at: [updatingTaskModel.newIndexPath], with: .automatic)
			})
		}
	}

	// MARK: - Private methods

	private func setupUI() {
		view.addSubview(tasksTableView)
	}

	private func setupLayout() {
		NSLayoutConstraint.activate([
			tasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func configureUI() {
		view.backgroundColor = .white
		title = Constants.title
	}
}

// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		viewData.sections.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewData.sections[section].title
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewData.sections[section].tasks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let task = viewData.sections[indexPath.section].tasks[indexPath.row]

		switch task {
		case .regularTask(let model):
			guard let cell = tableView.dequeue(type: RegularTaskTableViewCell.self, for: indexPath) else { return UITableViewCell() }
			cell.configure(with: model)
			return cell
		case .importantTask(let model):
			guard let cell = tableView.dequeue(type: ImportantTaskTableViewCell.self, for: indexPath) else { return UITableViewCell() }
			cell.configure(with: model)
			return cell
		}
	}
}
