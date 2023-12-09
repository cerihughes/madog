//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitSingleContainerUI<T>: ContainerUI<T, SplitSingleUITokenData<T>, UISplitViewController> {
    override func populateContainer(tokenData: SplitSingleUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let primary = try createContentViewController(token: tokenData.primaryToken)

        let secondary = try tokenData.secondaryToken.flatMap {
            try createContentViewController(token: $0)
        }

        containerViewController.preferredDisplayMode = .oneBesideSecondary
        containerViewController.presentsWithGesture = false
        containerViewController.viewControllers = [primary, secondary]
            .compactMap { $0 }
    }
}

extension SplitSingleContainerUI: SplitSingleContainer {
    // MARK: - SplitSingleContainer

    func showDetail(token: Token<T>) throws {
        let viewController = try createContentViewController(token: token)
        containerViewController.showDetailViewController(viewController, sender: nil)
    }
}

extension SplitSingleContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SplitSingleUITokenData<T>, UISplitViewController> {
            SplitSingleContainerUI(containerViewController: .init())
        }
    }
}
