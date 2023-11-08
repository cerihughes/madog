//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TabBarContainerUI<T>: ContainerUI<T>, MultiContainer {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokenData.tokens.compactMap { registry.createViewController(from: $0, container: self) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}

extension TabBarContainerUI {
    struct Factory: MultiContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> ContainerUI<T>? {
            TabBarContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}
