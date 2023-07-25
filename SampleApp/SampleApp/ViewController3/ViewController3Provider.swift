//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

private let vc3Identifier = "vc3Identifier"

class ViewController3Provider: ViewControllerProvider {
    private var sharedService: Any?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let serviceProvider = serviceProviders[serviceProvider1Name] as? ServiceProvider1 {
            sharedService = serviceProvider.somethingShared
        }
    }

    func createViewController(token: SampleToken, context: AnyContext<SampleToken>) -> UIViewController? {
        guard
            token.identifier == vc3Identifier,
            let context = context as? AnySplitUIContext<SampleToken>
        else { return nil }

        let viewController = ViewController3(context: context)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        return viewController
    }
}

extension SampleToken {
    static var vc3: SampleToken {
        SampleToken(identifier: vc3Identifier, data: [:])
    }
}
