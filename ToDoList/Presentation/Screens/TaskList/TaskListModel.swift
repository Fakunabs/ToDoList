//
//  TaskListModel.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 21.02.2023.
//

import Foundation

/// Модель экрана списка задач.
enum TaskListModel {

	// MARK: - Use cases

	enum FetchTaskList {
		struct Response {
			let presenterData: PresenterData
			let output: ITaskListInteractorOutput
		}
	}

	enum UpdateTask {
		struct Response {
			let presenterData: PresenterData
			let output: ITaskListInteractorOutput
			let oldIndexPath: IndexPath
			let newIndexPath: IndexPath
		}
	}

	// MARK: - ViewModel

	/// Модель данных вью.
	struct ViewModel {

		enum ResponseResult {
			case updatingTaskList(model: ViewData)
			case updatingTask(model: UpdatingTaskModel)
		}

		let responseResult: ResponseResult
	}
}

// MARK: - Nested models

extension TaskListModel {

	/// Модель данных, используемая презентером.
	/// Содержит "сырые" данные о секциях и задачах (в необходимом порядке).
	struct PresenterData {

		enum Section {
			case uncompleted(tasks: [Task])
			case completed(tasks: [Task])
		}

		let sections: [Section]
	}

	/// Модель данных, используемая вью.
	/// Содержит подготовленные данные, необходимые для отображения задач на вью.
	struct ViewData {

		struct RegularTask {
			let title: String
			let checkboxImageName: String
			let completionCheckboxTapAction: () -> Void
		}

		struct ImportantTask {
			let title: String
			let checkboxImageName: String
			let isExpired: Bool
			let priorityText: String
			let executionDate: String
			let completionCheckboxTapAction: () -> Void
		}

		enum Task {
			case regularTask(RegularTask)
			case importantTask(ImportantTask)
		}

		struct Section {
			let title: String
			let tasks: [Task]
		}

		let sections: [Section]
	}

	/// Модель данных, используемая для обновления задачи в списке.
	struct UpdatingTaskModel {
		let viewData: ViewData
		let oldIndexPath: IndexPath
		let newIndexPath: IndexPath
	}
}
