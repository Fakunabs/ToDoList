//
//  ConfigurableTableCell.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

/// Конфигурируемая ячейка таблицы.
protocol IConfigurableTableCell: UITableViewCell {
	associatedtype ConfigurationModel

	/// Конфигурирует ячейку.
	/// - Parameter model: Конфигурационная модель данных ячейки.
	func configure(with model: ConfigurationModel)
}
