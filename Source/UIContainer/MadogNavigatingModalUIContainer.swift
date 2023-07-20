//
//  MadogNavigatingModalUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

open class MadogNavigatingModalUIContainer<T>: MadogModalUIContainer<T>, ForwardBackNavigationContext {
    open func provideNavigationController() -> UINavigationController? {
        // OVERRIDE
        nil
    }

    // MARK: - ForwardBackNavigationContext

    public func navigateForward(token: T, animated: Bool) -> Bool {
        guard
            let toViewController = registry.createViewController(from: token, context: self),
            let navigationController = provideNavigationController()
        else {
            return false
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return true
    }

    public func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else {
            return false
        }

        return navigationController.popViewController(animated: animated) != nil
    }

    public func navigateBackToRoot(animated _: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else {
            return false
        }

        return navigationController.popToRootViewController(animated: true) != nil
    }
}
