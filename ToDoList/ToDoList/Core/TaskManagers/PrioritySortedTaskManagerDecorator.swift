//
//  PrioritySortedTaskManagerDecorator.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 18.02.2023.
//

import Foundation

/// Декоратор менеджера задач, который управляет задачами с учётом их сортировки по приоритету.
final class PrioritySortedTaskManagerDecorator: ITaskManager {

	// Properties
	private let taskManager: ITaskManager

	// MARK: - Initialization

	init(taskManager: ITaskManager) {
		self.taskManager = taskManager
	}

	// MARK: - ITaskManager

	var allTasks: [Task] {
		taskManager.allTasks.sortedByPriority()
	}

	var completedTasks: [Task] {
		taskManager.completedTasks.sortedByPriority()
	}

	var uncompletedTasks: [Task] {
		taskManager.uncompletedTasks.sortedByPriority()
	}

	func addTask(_ task: Task) {
		taskManager.addTask(task)
	}

	func addTasks(_ tasks: [Task]) {
		taskManager.addTasks(tasks)
	}

	@discardableResult
	func deleteTask(_ task: Task) -> Bool {
		taskManager.deleteTask(task)
	}
}

private extension Array where Element == Task {

	// Обеспечивает сортировку, при которой важные задачи располагаются первее обычных (первый критерий),
	// важные с более высоким приоритетом первее важных с более низким приоритетом (второй критерий),
	// а невыполненные первее выполненных (третий критерий)
	func sortedByPriority() -> [Task] {
		self.sorted(by: { task1, task2 in
			switch (task1, task2) {
			case (_ as ImportantTask, _ as RegularTask):
				return true
			case (_ as RegularTask, _ as ImportantTask):
				return false
			case (let task1 as ImportantTask, let task2 as ImportantTask):
				guard task1.priority != task2.priority else { return task1.isCompleted == false }
				return task1.priority > task2.priority
			case (let task1 as RegularTask, _ as RegularTask):
				return task1.isCompleted == false
			default:
				return true
			}
		})
	}
}
