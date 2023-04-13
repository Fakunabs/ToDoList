//
//  TaskRepositoryStub.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

/// Репозиторий, предоставляющий задачи для тестирования.
final class TaskRepositoryStub: ITaskRepository {

	// MARK: - ITaskRepository

	func getTaskList(completion: @escaping (Result<[Task], Error>) -> Void) {
		completion(.success(TaskRepositoryStub.stubTasks))
	}
}

private extension TaskRepositoryStub {

	// Временный метод для тестирования
	static var stubTasks: [Task] {
		let tasks: [Task] = [
			RegularTask(title: "To clean the room"),
			RegularTask(title: "Learning English"),
			RegularTask(title: "Walk"),
			RegularTask(title: "To wash the dishes"),
			ImportantTask(
				title: "Workout",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())!,
				priority: .medium
			),
			ImportantTask(
				title: "To fix shoes",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -5), to: Date())!,
				priority: .medium
			),
			ImportantTask(
				title: "Homework",
				creationDate: Date(),
				priority: .high
			),
			ImportantTask(
				title: "Relax",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())!,
				priority: .high
			),
			ImportantTask(
				title: "To bake coockies and three cakes (for two lines in title)",
				creationDate: Calendar.current.date(byAdding: DateComponents(day: -4), to: Date())!,
				priority: .low
			)
		]
		tasks
			.enumerated()
			.forEach { $1.isCompleted = $0.isMultiple(of: 2) }
		return tasks.shuffled()
	}
}
