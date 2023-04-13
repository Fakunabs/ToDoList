//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 21.02.2023.
//

import Foundation

/// Презентер экрана списка задач.
protocol ITaskListPresenter: AnyObject {
	/// Преподносит вью список задач.
	func presentTaskList(response: TaskListModel.FetchTaskList.Response)
	/// Преподносит вью обновлённую задачу.
	func presentUpdatedTask(response: TaskListModel.UpdateTask.Response)
}

private extension ImportantTask.Priority {

	/// Текстовое описание приоритета.
	var description: String {
		switch self {
		case .low:
			return "low"
		case .medium:
			return "medium"
		case .high:
			return "high"
		}
	}
}

private enum Constants {
	static let completedTasksSectionTitle = "Completed tasks"
	static let uncompletedTasksSectionTitle = "Uncompleted tasks"
	static let completedCheckboxImageName = "checkmark.circle.fill"
	static let uncompletedCheckboxImageName = "circle"
	static let priorityLabelText = "Priority: "
}

/// Презентер экрана списка задач.
final class TaskListPresenter: ITaskListPresenter {
	
	// Properties
	weak var view: ITaskListView?
	
	// MARK: - ITaskListPresenter
	
	func presentTaskList(response: TaskListModel.FetchTaskList.Response) {
		let viewData = convertToViewData(response.presenterData, output: response.output)
		let viewModel = TaskListModel.ViewModel(responseResult: .updatingTaskList(model: viewData))
		view?.render(viewModel: viewModel)
	}
	
	func presentUpdatedTask(response: TaskListModel.UpdateTask.Response) {
		let viewData = convertToViewData(response.presenterData, output: response.output)
		let updatingTaskModel = TaskListModel.UpdatingTaskModel(
			viewData: viewData,
			oldIndexPath: response.oldIndexPath,
			newIndexPath: response.newIndexPath
		)
		let viewModel = TaskListModel.ViewModel(responseResult: .updatingTask(model: updatingTaskModel))
		view?.render(viewModel: viewModel)
	}
	
	// MARK: - Private methods
	
	private func convertToViewData(_ presenterData: TaskListModel.PresenterData, output: ITaskListInteractorOutput) -> TaskListModel.ViewData {
		let viewDataSections: [TaskListModel.ViewData.Section] = presenterData.sections.map {
			switch $0 {
			case .uncompleted(let tasks):
				return TaskListModel.ViewData.Section(
					title: Constants.uncompletedTasksSectionTitle,
					tasks: tasks.map { mapTask($0, output: output) }
				)
			case .completed(let tasks):
				return TaskListModel.ViewData.Section(
					title: Constants.completedTasksSectionTitle,
					tasks: tasks.map { mapTask($0, output: output) }
				)
			}
		}
		return TaskListModel.ViewData(sections: viewDataSections)
	}
	
	private func mapTask(_ task: Task, output: ITaskListInteractorOutput) -> TaskListModel.ViewData.Task {
		switch task {
		case let importantTask as ImportantTask:
			let task = TaskListModel.ViewData.ImportantTask(
				title: importantTask.title,
				checkboxImageName: importantTask.isCompleted ? Constants.completedCheckboxImageName : Constants.uncompletedCheckboxImageName,
				isExpired: importantTask.isExpired,
				priorityText: Constants.priorityLabelText + importantTask.priority.description,
				executionDate: importantTask.executionDate?.formatted(date: .numeric, time: .omitted) ?? "No executionDate",
				completionCheckboxTapAction: { [weak output] in
					output?.needSwitchCompletedState(for: task)
				}
			)
			return .importantTask(task)
		case let task:
			let task = TaskListModel.ViewData.RegularTask(
				title: task.title,
				checkboxImageName: task.isCompleted ? Constants.completedCheckboxImageName : Constants.uncompletedCheckboxImageName,
				completionCheckboxTapAction: { [weak output] in
					output?.needSwitchCompletedState(for: task)
				}
			)
			return .regularTask(task)
		}
	}
}
