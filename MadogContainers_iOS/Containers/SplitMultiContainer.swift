//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitMultiContainer<T>: MadogUIContainer<T>, SplitMultiContext {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) {
        super.init(registry: registry, viewController: splitController)

        guard let primary = registry.createViewController(from: tokenData.primaryToken, context: self) else {
            return nil
        }

        let navigationController = UINavigationController()
        navigationController.viewControllers = tokenData.secondaryTokens
            .compactMap { registry.createViewController(from: $0, context: self) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primary, navigationController]
    }

    // MARK: - SplitMultiContext

    func showDetail(tokens: [T]) -> Bool {
        let navigationController = UINavigationController()
        navigationController.viewControllers = tokens
            .compactMap { registry.createViewController(from: $0, context: self) }
        splitController.showDetailViewController(navigationController, sender: nil)
        return true
    }
}

struct SplitMultiFactory<T>: SplitMultiContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) -> MadogUIContainer<T>? {
        SplitMultiContainer(registry: registry, tokenData: tokenData)
    }
}
