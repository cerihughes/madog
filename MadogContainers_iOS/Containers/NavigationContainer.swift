//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class NavigationContainer<VC, C, T>: MadogNavigatingModalUIContainer<T> where VC: ViewController {
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<VC, C, T>) {
        super.init(registry: registry, viewController: navigationController)

        guard let viewController = provideViewController(intent: tokenData.intent) else { return nil }
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}

struct NavigationContainerFactory<T>: SingleContainerFactory {
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: SingleUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>? where VC: UIViewController {
        NavigationContainer(registry: registry, tokenData: tokenData)
    }
}
