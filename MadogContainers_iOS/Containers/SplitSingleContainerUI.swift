//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitSingleContainerUI<T>: ContainerUI<T>, SplitSingleContainer {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) {
        super.init(registry: registry, viewController: splitController)

        guard let primary = registry.createViewController(from: tokenData.primaryToken, container: self) else {
            return nil
        }

        let secondary = tokenData.secondaryToken.flatMap { registry.createViewController(from: $0, container: self) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primary, secondary]
            .compactMap { $0 }
    }

    // MARK: - SplitSingleContainer

    func showDetail(token: T) -> Bool {
        guard let viewController = registry.createViewController(from: token, container: self) else { return false }
        splitController.showDetailViewController(viewController, sender: nil)
        return true
    }
}

extension SplitSingleContainerUI {
    struct Factory: SplitSingleContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> ContainerUI<T>? {
            SplitSingleContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}
