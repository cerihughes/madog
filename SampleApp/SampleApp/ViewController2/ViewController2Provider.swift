//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class ViewController2Provider: ViewControllerProvider {
    private var sharedService: Any?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let serviceProvider = serviceProviders[serviceProvider1Name] as? ServiceProvider1 {
            sharedService = serviceProvider.somethingShared
        }
    }

    func createViewController(token: SampleToken, container: AnyContainer<SampleToken>) -> UIViewController? {
        guard let sharedService, case let .vc2(stringData) = token else { return nil }

        let viewController = ViewController2(
            sharedService: sharedService,
            stringData: stringData,
            container: container
        )
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        return viewController
    }
}
