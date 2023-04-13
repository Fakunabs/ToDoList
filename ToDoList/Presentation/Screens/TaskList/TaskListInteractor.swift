//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 18.02.2023.
//

import Foundation

/// Интерактор экрана списка задач.
protocol ITaskListInteractor: AnyObject {
	/// Запрашивает список задач.
	func requestTaskList()
}

/// Протокол для делегирования интерактору обработки событий списка задач.
protocol ITaskListInteractorOutput: AnyObject {
	/// Уведомляет о необходимости изменения состояния выполненности задачи.
	/// - Parameter task: Задача, у которой необходимо изменить состояние выполненности.
	func needSwitchCompletedState(for task: Task)
}

/// Интерактор экрана списка задач.
final class TaskListInteractor: ITaskListInteractor {

	// Properties
	private let presenter: ITaskListPresenter
	private let taskRepository: ITaskRepository
	private let taskListDataAdapter: ITaskListDataAdapter

	// MARK: - Initialization

	init(
		presenter: ITaskListPresenter,
		taskRepository: ITaskRepository,
		taskListDataAdapter: ITaskListDataAdapter
	) {
		self.presenter = presenter
		self.taskRepository = taskRepository
		self.taskListDataAdapter = taskListDataAdapter
	}
	
	// MARK: - ITaskListInteractor
	
	func requestTaskList() {
		taskRepository.getTaskList { [weak self] result in
			guard let self = self else { return }

			switch result {
			case .success(let tasks):
				self.taskListDataAdapter.loadToManager(tasks)

				let response = TaskListModel.FetchTaskList.Response(
					presenterData: self.taskListDataAdapter.presenterData,
					output: self
				)
				self.presenter.presentTaskList(response: response)
			case .failure(let error):
				// Временно
				print(error.localizedDescription)
			}
		}
	}
}

// MARK: - ITaskListInteractorOutput

extension TaskListInteractor: ITaskListInteractorOutput {

	func needSwitchCompletedState(for task: Task) {
		guard let oldIndexPath = taskListDataAdapter.indexPath(for: task) else { return }
		task.isCompleted.toggle()
		guard let newIndexPath = taskListDataAdapter.indexPath(for: task) else { return }
		
		let response = TaskListModel.UpdateTask.Response(
			presenterData: taskListDataAdapter.presenterData,
			output: self,
			oldIndexPath: oldIndexPath,
			newIndexPath: newIndexPath
		)
		presenter.presentUpdatedTask(response: response)
	}
}
