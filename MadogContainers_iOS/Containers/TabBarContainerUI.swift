//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TabBarContainerUI<T>: ContainerUI<T, MultiUITokenData<T>, UITabBarController>, MultiContainer {
    private let tabBarController = UITabBarController()

    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: MultiUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        let viewControllers = try tokenData.tokens.compactMap {
            try createContentViewController(contentFactory: contentFactory, from: $0)
        }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}

extension TabBarContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, MultiUITokenData<T>, UITabBarController> {
            TabBarContainerUI(containerViewController: .init())
        }
    }
}
