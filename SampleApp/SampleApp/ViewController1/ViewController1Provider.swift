//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class ViewController1Provider: ViewControllerProvider {
    private var sharedService: Any?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let serviceProvider = serviceProviders[serviceProvider1Name] as? ServiceProvider1 {
            sharedService = serviceProvider.somethingShared
        }
    }

    func createViewController(token: SampleToken, container: AnyContainer<SampleToken>) -> UIViewController? {
        guard let sharedService, token == .vc1 else { return nil }

        let viewController = ViewController1(sharedService: sharedService, container: container)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }
}
