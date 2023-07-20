//
//  MadogModalUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

open class MadogModalUIContainer<T>: MadogUIContainer<T>, ModalContext {
    public private(set) var registry: AnyRegistry<T>
    var modalPresentation: ModalPresentation = DefaultModalPresentation()

    public init(registry: AnyRegistry<T>, viewController: UIViewController) {
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
        identifier: MadogUIIdentifier<VC, C, T>,
        tokenData: TokenData<T>,
        presentationStyle: UIModalPresentationStyle?,
        transitionStyle: UIModalTransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<T, C>? where VC: UIViewController, C: Context<T> {
        guard
            let delegate = delegate,
            let container = delegate.createUI(
                identifier: identifier,
                tokenData: tokenData,
                isModal: true,
                customisation: customisation
            ),
            let context = container as? C
        else { return nil }

        let presentedViewController = container.viewController
        let result = modalPresentation.presentModally(
            presenting: viewController,
            modal: presentedViewController,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            completion: completion
        )
        return result ? createModalToken(viewController: presentedViewController, context: context) : nil
    }
    // swiftlint:enable function_parameter_count

    public func closeModal<C>(
        token: AnyModalToken<T, C>,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool where C: Context<T> {
        guard let token = token as? ModalTokenImplementation<T, C> else { return false }
        closeContext(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    private func closeContext(
        presentedViewController: UIViewController,
        animated: Bool = false,
        completion: CompletionBlock? = nil
    ) {
        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            closeContext(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContext(for: presentedViewController)
    }

    public final func createModalToken<C>(
        viewController: UIViewController,
        context: C
    ) -> AnyModalToken<T, C> where C: Context<T> {
        ModalTokenImplementation(viewController: viewController, context: context)
    }
}
