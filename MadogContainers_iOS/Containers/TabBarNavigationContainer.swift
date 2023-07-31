//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigationContainer<T>: MadogNavigatingModalUIContainer<T>, MultiContext {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, creationContext: CreationContext<T>, tokenData: MultiUITokenData<T>) {
        super.init(registry: registry, creationContext: creationContext, viewController: tabBarController)

        let viewControllers = tokenData
            .intents.compactMap { provideViewController(intent: $0) }
            .map { UINavigationController(rootViewController: $0) }

        tabBarController.viewControllers = viewControllers
    }

    override func provideNavigationController() -> UINavigationController? {
        tabBarController.selectedViewController as? UINavigationController
    }

    // MARK: - MultiContext

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}

struct TabBarNavigationContainerFactory<T>: MultiContainerFactory {
    func createContainer(
        registry: AnyRegistry<T>,
        creationContext: MadogUIContainer<T>.CreationContext<T>,
        tokenData: MultiUITokenData<T>
    ) -> MadogUIContainer<T>? {
        TabBarNavigationContainer(registry: registry, creationContext: creationContext, tokenData: tokenData)
    }
}
