//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class SplitSingleContainer<T>: MadogUIContainer<T>, SplitSingleContext {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) {
        super.init(registry: registry, viewController: splitController)

        guard let primary = registry.createViewController(from: tokenData.primaryToken, context: self) else {
            return nil
        }

        let secondary = tokenData.secondaryToken.flatMap { registry.createViewController(from: $0, context: self) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primary, secondary]
            .compactMap { $0 }
    }

    // MARK: - SplitContext

    func showDetail(token: T) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else { return false }
        splitController.showDetailViewController(viewController, sender: nil)
        return true
    }
}

struct SplitSingleFactory<T>: SplitSingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> MadogUIContainer<T>? {
        SplitSingleContainer(registry: registry, tokenData: tokenData)
    }
}
