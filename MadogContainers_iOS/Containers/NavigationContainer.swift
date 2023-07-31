//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class NavigationContainer<T>: MadogNavigatingModalUIContainer<T> {
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<T>, creationContext: CreationContext<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, creationContext: creationContext, viewController: navigationController)

        guard let viewController = provideViewController(intent: tokenData.intent) else { return nil }
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}

struct NavigationContainerFactory<T>: SingleContainerFactory {
    func createContainer(
        registry: AnyRegistry<T>,
        creationContext: MadogUIContainer<T>.CreationContext<T>,
        tokenData: SingleUITokenData<T>
    ) -> MadogUIContainer<T>? {
        NavigationContainer(registry: registry, creationContext: creationContext, tokenData: tokenData)
    }
}
