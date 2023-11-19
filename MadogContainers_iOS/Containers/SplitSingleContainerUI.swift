//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitSingleContainerUI<T>: ContainerUI<T, SplitSingleUITokenData<T>, UISplitViewController>, SplitSingleContainer {
    private var contentFactory: AnyContainerUIContentFactory<T>?

    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: SplitSingleUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        self.contentFactory = contentFactory

        let primary = try createContentViewController(contentFactory: contentFactory, from: tokenData.primaryToken)

        let secondary = try tokenData.secondaryToken.flatMap {
            try createContentViewController(contentFactory: contentFactory, from: $0)
        }

        containerViewController.preferredDisplayMode = .oneBesideSecondary
        containerViewController.presentsWithGesture = false
        containerViewController.viewControllers = [primary, secondary]
            .compactMap { $0 }
    }

    // MARK: - SplitSingleContainer

    func showDetail(token: Token<T>) -> Bool {
        guard
            let contentFactory,
            let viewController = try? createContentViewController(contentFactory: contentFactory, from: token)
        else { return false }
        containerViewController.showDetailViewController(viewController, sender: nil)
        return true
    }
}

extension SplitSingleContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SplitSingleUITokenData<T>, UISplitViewController> {
            SplitSingleContainerUI(containerViewController: .init())
        }
    }
}
