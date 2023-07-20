//
//  MadogModalUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

open class MadogModalUIContainer<Token>: MadogUIContainer<Token>, ModalContext {
    public private(set) var registry: AnyRegistry<Token>
    var modalPresentation: ModalPresentation = DefaultModalPresentation()

    public init(registry: AnyRegistry<Token>, viewController: UIViewController) {
        self.registry = registry
        super.init(viewController: viewController)
    }

    override public func close(
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool {
        closeContext(presentedViewController: viewController, animated: animated, completion: completion)
        return true
    }

    // MARK: - ModalContext

    // swiftlint:disable function_parameter_count
    public func openModal<VC, C>(
        identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        presentationStyle: UIModalPresentationStyle?,
        transitionStyle: UIModalTransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<Token, C>? where VC: UIViewController, C: Context<Token> {
        guard
            let delegate = delegate,
            let container = delegate.createUI(
                identifier: identifier,
                tokenData: tokenData,
                isModal: true,
                customisation: customisation
            )
        else {
            return nil
        }

        let presentedViewController = container.container.viewController
        let result = modalPresentation.presentModally(
            presenting: viewController,
            modal: presentedViewController,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            completion: completion
        )
        return result ? createModalToken(viewController: presentedViewController, context: container.context) : nil
    }
    // swiftlint:enable function_parameter_count

    public func closeModal<C>(
        token: AnyModalToken<Token, C>,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool where C: Context<Token> {
        guard let token = token as? ModalTokenImplementation<Token, C> else { return false }

        closeContext(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    private func closeContext(presentedViewController: UIViewController,
                              animated: Bool = false,
                              completion: CompletionBlock? = nil) {
        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            closeContext(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContext(for: presentedViewController)
    }

    public final func createModalToken<C>(
        viewController: UIViewController,
        context: C
    ) -> AnyModalToken<Token, C> where C: Context<Token> {
        ModalTokenImplementation(viewController: viewController, context: context)
    }
}
