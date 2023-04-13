//
//  TaskListDataAdapter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 19.02.2023.
//

import Foundation

/// Адаптер, предоставляющий презентационные данные о списке задач.
protocol ITaskListDataAdapter: AnyObject {
	/// Модель данных `TaskListModel.PresenterData`.
	var presenterData: TaskListModel.PresenterData { get }

	/// Загрузка данных о задачах в менеджер.
	/// - Parameter tasks: Список задач.
	func loadToManager(_ tasks: [Task])
	/// Возвращает IndexPath для переданной задачи.
	/// - Parameter task: Задача.
	/// - Returns: При нахождении задачи возвращается её `IndexPath`, в противном случае — `nil`.
	func indexPath(for task: Task) -> IndexPath?
}

/// Адаптер, предоставляющий презентационные данные о списке задач.
final class TaskListDataAdapter: ITaskListDataAdapter {

	// Properties
	private let taskManager: ITaskManager

	// MARK: - Initialization

	init(taskManager: ITaskManager) {
		self.taskManager = taskManager
	}

	// MARK: - ITaskListSectionsAdapter

	var presenterData: TaskListModel.PresenterData {
		TaskListModel.PresenterData(
			sections: [
				TaskListModel.PresenterData.Section.uncompleted(tasks: taskManager.uncompletedTasks),
				TaskListModel.PresenterData.Section.completed(tasks: taskManager.completedTasks),
			]
		)
	}

	func loadToManager(_ tasks: [Task]) {
		taskManager.addTasks(tasks)
	}

	func indexPath(for task: Task) -> IndexPath? {
		let tasks = task.isCompleted ? taskManager.completedTasks : taskManager.uncompletedTasks
		guard let row = tasks.firstIndex(where: { task === $0 }) else { return nil }
		return IndexPath(row: row, section: task.isCompleted ? 1 : 0)
	}
}
