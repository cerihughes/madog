//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitMultiContainerUI<T>: ContainerUI<T, SplitMultiUITokenData<T>, UISplitViewController>, SplitMultiContainer {
    private var contentFactory: AnyContainerUIContentFactory<T>?

    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: SplitMultiUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        self.contentFactory = contentFactory

        let primary = try createContentViewController(contentFactory: contentFactory, from: tokenData.primaryToken)

        guard let navigationController = navigationController(for: tokenData.secondaryTokens) else { return }

        containerViewController.preferredDisplayMode = .oneBesideSecondary
        containerViewController.presentsWithGesture = false
        containerViewController.viewControllers = [primary, navigationController]
    }

    private func navigationController(for secondaryTokens: [Token<T>]) -> UINavigationController? {
        guard let contentFactory else { return nil }

        let navigationController = UINavigationController()
        navigationController.viewControllers = secondaryTokens
            .compactMap { try? createContentViewController(contentFactory: contentFactory, from: $0) }
        return navigationController
    }

    // MARK: - SplitMultiContainer

    func showDetail(tokens: [Token<T>]) -> Bool {
        guard let navigationController = navigationController(for: tokens) else { return false }
        containerViewController.showDetailViewController(navigationController, sender: nil)
        return true
    }
}

extension SplitMultiContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SplitMultiUITokenData<T>, UISplitViewController> {
            SplitMultiContainerUI(containerViewController: .init())
        }
    }
}
