//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

typealias SplitUIContext<T> = ModalContext<T> & SplitContext<T>
typealias AnySplitUIContext<T> = any SplitUIContext<T>
extension MadogUIIdentifier
where VC == UISplitViewController, C == AnySplitUIContext<T>, TD == SplitSingleUITokenData<T> {
    static func split() -> Self { MadogUIIdentifier("splitViewControllerIdentifier") }
}

protocol SplitContext<T>: Context {
    @discardableResult
    func showDetail(token: T) -> Bool
}

class SplitUI<T>: MadogModalUIContainer<T>, SplitContext {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) {
        super.init(registry: registry, viewController: splitController)

        guard let primaryViewController = provideViewController(intent: tokenData.primaryIntent) else { return nil }

        let secondaryViewController = tokenData.secondaryIntent.flatMap { provideViewController(intent: $0) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primaryViewController, secondaryViewController]
            .compactMap { $0 }
    }

    // MARK: - SplitContext

    func showDetail(token: T) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else { return false }
        splitController.showDetailViewController(viewController, sender: nil)
        return true
    }
}

struct SplitUIFactory<T>: SplitSingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> MadogModalUIContainer<T>? {
        SplitUI(registry: registry, tokenData: tokenData)
    }
}
