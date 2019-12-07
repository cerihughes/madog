//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
internal class NavigationUI<Token>: MadogSingleUIContainer<Token>, ForwardBackNavigationContext {
	private let navigationController = UINavigationController()

	internal init() {
		super.init(viewController: navigationController)
	}

	// MARK: - MadogSingleUIContext

	internal override func renderInitialView(with token: Token) -> Bool {
		guard let viewController = registry.createViewController(from: token, context: self) else {
			return false
		}

		navigationController.setViewControllers([viewController], animated: false)
		return true
	}

	// MARK: - ForwardBackNavigationContext

	internal func navigateForward(token: Any, animated: Bool) -> Bool {
		guard let token = token as? Token,
			let viewController = registry.createViewController(from: token, context: self) else {
			return false
		}

		navigationController.pushViewController(viewController, animated: animated)
		return true
	}

	internal func navigateBack(animated: Bool) -> Bool {
		return navigationController.popViewController(animated: animated) != nil
	}

	internal func navigateBackToRoot(animated _: Bool) -> Bool {
		return navigationController.popToRootViewController(animated: true) != nil
	}
}
