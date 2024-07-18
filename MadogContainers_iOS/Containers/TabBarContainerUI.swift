//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TabBarContainerUI<T>: ContainerUI<T, MultiUITokenData<T>, UITabBarController>, MultiContainer {
    override func populateContainer(tokenData: MultiUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let viewControllers = try tokenData.tokens.map {
            try createContentViewController(token: $0)
        }

        containerViewController.viewControllers = viewControllers
    }

    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { containerViewController.selectedIndex }
        set { containerViewController.selectedIndex = newValue }
    }
}

extension TabBarContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, MultiUITokenData<T>, UITabBarController> {
            TabBarContainerUI(containerViewController: .init())
        }
    }
}
