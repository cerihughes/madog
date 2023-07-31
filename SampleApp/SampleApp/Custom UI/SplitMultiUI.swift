//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

typealias SplitMultiUIContext<T> = ModalContext<T> & SplitMultiContext<T>
typealias AnySplitMultiUIContext<T> = any SplitMultiUIContext<T>
extension MadogUIIdentifier
where VC == UISplitViewController, C == AnySplitMultiUIContext<T>, TD == SplitMultiUITokenData<T> {
    static func splitMulti() -> Self { MadogUIIdentifier("splitViewControllerIdentifier") }
}

protocol SplitMultiContext<T>: Context {
    @discardableResult
    func showDetail(tokens: [T]) -> Bool
}

class SplitMultiUI<T>: MadogModalUIContainer<T>, SplitMultiContext {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, creationContext: CreationContext<T>, tokenData: SplitMultiUITokenData<T>) {
        super.init(registry: registry, creationContext: creationContext, viewController: splitController)

        guard let primaryViewController = provideViewController(intent: tokenData.primaryIntent) else { return nil }

        let navigationController = UINavigationController()
        navigationController.viewControllers = tokenData.secondaryIntents
            .compactMap { provideViewController(intent: $0) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primaryViewController, navigationController]
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

struct SplitMultiUIFactory<T>: SplitMultiContainerFactory {
    func createContainer(
        registry: AnyRegistry<T>,
        creationContext: MadogUIContainer<T>.CreationContext<T>,
        tokenData: SplitMultiUITokenData<T>
    ) -> MadogUIContainer<T>? {
        SplitMultiUI(registry: registry, creationContext: creationContext, tokenData: tokenData)
    }
}
