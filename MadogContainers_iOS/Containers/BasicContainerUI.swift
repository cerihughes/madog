//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class BasicContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, BasicUIContainerViewController> {
    override func populateContainer(tokenData: SingleUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let viewController = try createContentViewController(token: tokenData.token)
        containerViewController.contentViewController = viewController
    }
}

extension BasicContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SingleUITokenData<T>, BasicUIContainerViewController> {
            BasicContainerUI(containerViewController: .init())
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
