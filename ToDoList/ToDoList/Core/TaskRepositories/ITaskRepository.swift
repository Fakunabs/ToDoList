//
//  ITaskRepository.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 15.02.2023.
//

import Foundation

/// Репозиторий задач.
protocol ITaskRepository {
	/// Получение списка задач.
	/// - Parameter completion: Обработчик завершения, в который возращается результат (массив задач, либо ошибка `Error`).
	func getTaskList(completion: @escaping (Result<[Task], Error>) -> Void)
}
