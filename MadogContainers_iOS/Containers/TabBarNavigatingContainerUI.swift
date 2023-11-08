//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigatingContainerUI<T>: NavigatingContainerUI<T>, MultiContainer {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokenData.tokens
            .compactMap { registry.createViewController(from: $0, container: self) }
            .map { UINavigationController(rootViewController: $0) }

        tabBarController.viewControllers = viewControllers
    }

    override func provideNavigationController() -> UINavigationController? {
        tabBarController.selectedViewController as? UINavigationController
    }

    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}

extension TabBarNavigatingContainerUI {
    struct Factory: MultiContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> ContainerUI<T>? {
            TabBarNavigatingContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}
