//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitMultiContainerUI<T>: ContainerUI<T>, SplitMultiContainer {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) {
        super.init(registry: registry, viewController: splitController)

        guard let primary = registry.createViewController(from: tokenData.primaryToken, container: self) else {
            return nil
        }

        let navigationController = UINavigationController()
        navigationController.viewControllers = tokenData.secondaryTokens
            .compactMap { registry.createViewController(from: $0, container: self) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primary, navigationController]
    }

    // MARK: - SplitMultiContainer

    func showDetail(tokens: [T]) -> Bool {
        let navigationController = UINavigationController()
        navigationController.viewControllers = tokens
            .compactMap { registry.createViewController(from: $0, container: self) }
        splitController.showDetailViewController(navigationController, sender: nil)
        return true
    }
}

extension SplitMultiContainerUI {
    struct Factory: SplitMultiContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) -> ContainerUI<T>? {
            SplitMultiContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}
