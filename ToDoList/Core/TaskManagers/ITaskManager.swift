//
//  ITaskManager.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 19.02.2023.
//

import Foundation

/// Менеджер задач.
protocol ITaskManager: AnyObject {
	/// Все задачи.
	var allTasks: [Task] { get }
	/// Выполненные задачи.
	var completedTasks: [Task] { get }
	/// Невыполненные задачи.
	var uncompletedTasks: [Task] { get }

	/// Добавлние задачи.
	/// - Parameter task: Задача, которую необходимо добавить.
	func addTask(_ task: Task)
	/// Добавлние задач.
	/// - Parameter tasks: Задачи, которые необходимо добавить.
	func addTasks(_ tasks: [Task])
	/// Удаление задачи.
	/// - Parameter task: Задача, которую необходимо удалить.
	/// - Returns: В случае успешного удаления задачи возвращается `true`, в противном случае — `false`.
	@discardableResult
	func deleteTask(_ task: Task) -> Bool
}
