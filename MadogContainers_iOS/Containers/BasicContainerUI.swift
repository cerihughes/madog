//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class BasicContainerUI<T>: ContainerUI<T> {
    private let containerController = BasicUIContainerViewController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: containerController)

        guard let viewController = registry.createViewController(from: tokenData.token, container: self) else {
            return nil
        }
        containerController.contentViewController = viewController
    }
}

extension BasicContainerUI {
    struct Factory: SingleContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T>? {
            BasicContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}

open class BasicUIContainerViewController: UIViewController {
    deinit {
        contentViewController = nil
    }

    var contentViewController: UIViewController? {
        didSet {
            removeContentViewController(oldValue)
            addContentViewController(contentViewController)
        }
    }

    private func removeContentViewController(_ viewController: UIViewController?) {
        if let viewController {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }

    private func addContentViewController(_ viewController: UIViewController?) {
        guard let viewController else { return }
        viewController.willMove(toParent: self)

        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: self)
    }
}
