//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class BasicNavigatingContainerUI<T>: NavigatingContainerUI<T> {
    override func populateContainer(tokenData: SingleUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let viewController = try createContentViewController(token: tokenData.token)
        containerViewController.setViewControllers([viewController], animated: false)
    }
}

extension BasicNavigatingContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SingleUITokenData<T>, NavigationController> {
            BasicNavigatingContainerUI(containerViewController: .init())
        }
    }
}
