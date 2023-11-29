//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitMultiContainerUI<T>: ContainerUI<T, SplitMultiUITokenData<T>, UISplitViewController>, SplitMultiContainer {
    override func populateContainer(tokenData: SplitMultiUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let primary = try createContentViewController(token: tokenData.primaryToken)

        let navigationController = try navigationController(for: tokenData.secondaryTokens)

        containerViewController.preferredDisplayMode = .oneBesideSecondary
        containerViewController.presentsWithGesture = false
        containerViewController.viewControllers = [primary, navigationController]
    }

    private func navigationController(for secondaryTokens: [Token<T>]) throws -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.viewControllers = try secondaryTokens
            .map { try createContentViewController(token: $0) }
        return navigationController
    }

    // MARK: - SplitMultiContainer

    func showDetail(tokens: [Token<T>]) throws {
        let navigationController = try navigationController(for: tokens)
        containerViewController.showDetailViewController(navigationController, sender: nil)
    }
}

extension SplitMultiContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SplitMultiUITokenData<T>, UISplitViewController> {
            SplitMultiContainerUI(containerViewController: .init())
        }
    }
}
