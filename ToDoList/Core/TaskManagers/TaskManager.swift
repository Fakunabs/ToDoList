//
//  TaskManager.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import Foundation

/// Менеджер задач.
class TaskManager: ITaskManager {

	// Properties
	private var tasks = [Task]()

	// MARK: - ITaskManager

	var allTasks: [Task] {
		tasks
	}

	var completedTasks: [Task] {
		tasks.filter { $0.isCompleted }
	}

	var uncompletedTasks: [Task] { 
		tasks.filter { !$0.isCompleted }
	}

	func addTask(_ task: Task) {
		tasks.append(task)
	}

	func addTasks(_ tasks: [Task]) {
		self.tasks = tasks
	}

	@discardableResult
	func deleteTask(_ task: Task) -> Bool {
		guard let index = tasks.firstIndex(where: { $0 === task }) else { return false }
		tasks.remove(at: index)
		return true
	}
}
