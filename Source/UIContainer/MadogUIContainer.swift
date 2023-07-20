//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

struct DelegateThing<Token, C> where C: Context {
    let container: MadogUIContainer<Token>
    let context: C
}

protocol MadogUIContainerDelegate<Token>: AnyObject {
    associatedtype Token

    func createUI<VC, C>(
        identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> DelegateThing<Token, C>? where VC: UIViewController, C: Context<Token>

    func context(for viewController: UIViewController) -> AnyContext<Token>?
    func releaseContext(for viewController: UIViewController)
}

open class MadogUIContainer<Token>: Context {
    weak var delegate: (any MadogUIContainerDelegate<Token>)?
    let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Context

    public var presentingContext: AnyContext<Token>? {
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
        to identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: UIViewController, C: Context<Token> {
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

        window.setRootViewController(container.container.viewController, transition: transition)
        return container.context
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
