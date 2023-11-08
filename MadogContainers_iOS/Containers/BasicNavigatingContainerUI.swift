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
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: navigationController)

        guard let viewController = registry.createViewController(from: tokenData.token, container: self) else {
            return nil
        }
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}

extension BasicNavigatingContainerUI {
    struct Factory: SingleContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T>? {
            BasicNavigatingContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}
