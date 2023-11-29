//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigatingContainerUI<T>: ContainerUI<T, MultiUITokenData<T>, UITabBarController> {
    override func populateContainer(tokenData: MultiUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let viewControllers = try tokenData.tokens
            .map { try createContentViewController(token: $0) }
            .map { UINavigationController(rootViewController: $0) }

        containerViewController.viewControllers = viewControllers
    }
}

extension TabBarNavigatingContainerUI: ForwardBackContainer {
    // MARK: - ForwardBackContainer

    func navigateForward(token: Token<T>, animated: Bool) throws {
        let toViewController = try createContentViewController(token: token)
        let navigationController = try provideNavigationController()
        navigationController.pushViewController(toViewController, animated: animated)
    }

    func navigateBack(animated: Bool) throws {
        let popped = try provideNavigationController().popViewController(animated: animated)
        if popped == nil {
            throw MadogError<T>.cannotNavigateBack
        }
    }

    func navigateBackToRoot(animated _: Bool) throws {
        let popped = try provideNavigationController().popToRootViewController(animated: true)
        if popped == nil {
            throw MadogError<T>.cannotNavigateBack
        }
    }

    private func provideNavigationController() throws -> UINavigationController {
        guard let nc = containerViewController.selectedViewController as? UINavigationController else {
            throw MadogError<T>.internalError("selectedViewController is not UINavigationController")
        }
        return nc
    }
}

extension TabBarNavigatingContainerUI: MultiContainer {
    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { containerViewController.selectedIndex }
        set { containerViewController.selectedIndex = newValue }
    }
}

extension TabBarNavigatingContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, MultiUITokenData<T>, UITabBarController> {
            TabBarNavigatingContainerUI(containerViewController: .init())
        }
    }
}
