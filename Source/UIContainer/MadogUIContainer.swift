//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

protocol MadogUIContainerDelegate: AnyObject {
    func createUI<VC, TD>(
        identifier: MadogUIIdentifier<VC, TD>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> MadogUIContainer? where VC: UIViewController, TD: TokenData

    func context(for viewController: UIViewController) -> Context?
    func releaseContext(for viewController: UIViewController)
}

open class MadogUIContainer: Context {
    weak var delegate: MadogUIContainerDelegate?
    let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Context

    public var presentingContext: Context? {
        guard let presentingViewController = viewController.presentingViewController else { return nil }
        return delegate?.context(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        // OVERRIDE
        false
    }

    public func change<VC, TD>(
        to identifier: MadogUIIdentifier<VC, TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> Context? where VC: UIViewController, TD: TokenData {
        guard
            let delegate,
            let window = viewController.resolvedWindow,
            let container = delegate.createUI(
                identifier: identifier,
                tokenData: tokenData,
                isModal: false,
                customisation: customisation
            )
        else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container
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
