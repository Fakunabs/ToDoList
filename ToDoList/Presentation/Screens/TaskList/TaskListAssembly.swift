//
//  TaskListAssembly.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

/// Сборщик экрана списка задач.
final class TaskListAssembly {

	func assemble() -> UIViewController {
		let presenter = TaskListPresenter()

		let taskManager = TaskManager()
		let taskListDataAdapter = TaskListDataAdapter(taskManager: PrioritySortedTaskManagerDecorator(taskManager: taskManager))
		let interactor = TaskListInteractor(
			presenter: presenter,
			taskRepository: TaskRepositoryStub(),
			taskListDataAdapter: taskListDataAdapter
		)

		let viewController = TaskListViewController(interactor: interactor)
		
		presenter.view = viewController
		return viewController
	}
}
