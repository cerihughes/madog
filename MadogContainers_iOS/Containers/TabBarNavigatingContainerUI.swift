//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigatingContainerUI<T>: ContainerUI<T, MultiUITokenData<T>, UITabBarController>, ForwardBackContainer, MultiContainer {
    private var contentFactory: AnyContainerUIContentFactory<T>?

    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: MultiUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        self.contentFactory = contentFactory

        let viewControllers = try tokenData.tokens
            .compactMap { try createContentViewController(contentFactory: contentFactory, from: $0) }
            .map { UINavigationController(rootViewController: $0) }

        containerViewController.viewControllers = viewControllers
    }

    // MARK: - ForwardBackContainer

    func navigateForward(token: Token<T>, animated: Bool) -> Bool {
        guard
            let contentFactory,
            let toViewController = try? createContentViewController(contentFactory: contentFactory, from: token),
            let navigationController = provideNavigationController()
        else { return false }

        navigationController.pushViewController(toViewController, animated: animated)
        return true
    }

    func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else { return false }
        return navigationController.popViewController(animated: animated) != nil
    }

    func navigateBackToRoot(animated _: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else { return false }
        return navigationController.popToRootViewController(animated: true) != nil
    }

    private func provideNavigationController() -> UINavigationController? {
        containerViewController.selectedViewController as? UINavigationController
    }

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
