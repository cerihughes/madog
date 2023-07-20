//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

protocol MadogUIContainerDelegate<T>: AnyObject {
    associatedtype T

    func createUI<VC, C>(
        identifier: MadogUIIdentifier<VC, C, T>,
        tokenData: TokenData<T>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> MadogUIContainer<T>? where VC: UIViewController, C: Context<T>

    func context(for viewController: UIViewController) -> AnyContext<T>?
    func releaseContext(for viewController: UIViewController)
}

open class MadogUIContainer<T>: Context {
    weak var delegate: (any MadogUIContainerDelegate<T>)?
    let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Context

    public var presentingContext: AnyContext<T>? {
        guard let presentingViewController = viewController.presentingViewController else {
            return nil
        }
        return delegate?.context(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        // OVERRIDE
        false
    }

    public func change<VC, C>(
        to identifier: MadogUIIdentifier<VC, C, T>,
        tokenData: TokenData<T>,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: UIViewController, C: Context<T> {
        guard let delegate = delegate,
            let window = viewController.resolvedWindow,
            let container = delegate.createUI(
                identifier: identifier,
                tokenData: tokenData,
                isModal: false,
                customisation: customisation
            )
        else {
            return nil
        }

        window.setRootViewController(container.viewController, transition: transition)
        return container as? C
    }
}

private extension UIViewController {
    var resolvedWindow: UIWindow? {
        if #available(iOS 13, *) {
            return view.window
        } else {
            // On iOS12, the window of a modally presenting VC can be nil
            return view.window ?? presentedViewController?.resolvedWindow
        }
    }
}
