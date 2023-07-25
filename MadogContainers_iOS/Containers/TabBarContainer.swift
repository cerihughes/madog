//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TabBarContainer<VC, C, T>: MadogModalUIContainer<T>, MultiContext where VC: ViewController {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokenData: MultiUITokenData<VC, C, T>) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokenData.intents.compactMap { provideViewController(intent: $0) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContext

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}

struct TabBarContainerFactory<T>: MultiContainerFactory {
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: MultiUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>? where VC: UIViewController {
        TabBarContainer(registry: registry, tokenData: tokenData)
    }
}
