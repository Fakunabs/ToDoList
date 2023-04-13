//
//  Task.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 11.02.2023.
//

import Foundation

/// Задача.
class Task {

	// Properties
	/// Заголовок.
	var title: String
	/// Выполнена ли задача.
	var isCompleted = false

	// MARK: - Initialization

	init(title: String) {
		self.title = title
	}
}
