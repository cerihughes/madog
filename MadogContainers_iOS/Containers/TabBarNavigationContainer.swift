//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigationContainer<T>: MadogNavigatingModalUIContainer<T>, MultiForwardBackNavigationContext {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokenData.tokens
            .compactMap { registry.createViewController(from: $0, context: self) }
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
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> MadogUIContainer<T>? {
        TabBarNavigationContainer(registry: registry, tokenData: tokenData)
    }
}