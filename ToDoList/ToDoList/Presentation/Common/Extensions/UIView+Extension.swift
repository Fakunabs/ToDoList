//
//  UIView+Extension.swift
//  ToDoList
//
//  Created by Evgeniy Novgorodov on 12.02.2023.
//

import UIKit

extension UIView {

	/// Подготавливает вью к использованию автолайаута.
	/// - Returns: Возвращается инстанс вью, у которого был вызван метод.
	@discardableResult
	func prepareForAutoLayout() -> Self {
		translatesAutoresizingMaskIntoConstraints = false
		return self
	}
}
