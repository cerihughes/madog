//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

open class MadogModalUIContainer<T>: MadogUIContainer<T>, ModalContext {
    public private(set) var registry: AnyRegistry<T>
    var modalPresentation: ModalPresentation = DefaultModalPresentation()

    public init(registry: AnyRegistry<T>, viewController: ViewController) {
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
    public func openModal<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<C>? where VC: ViewController, TD: TokenData {
        guard
            let container = delegate?.createUI(
                identifier: identifier.value,
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
        token: AnyModalToken<C>,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool {
        guard let token = token as? ModalTokenImplementation<C> else { return false }
        closeContext(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    private func closeContext(
        presentedViewController: ViewController,
        animated: Bool = false,
        completion: CompletionBlock? = nil
    ) {
        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            closeContext(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContext(for: presentedViewController)
    }

    public final func createModalToken<C>(viewController: ViewController, context: C) -> AnyModalToken<C> {
        ModalTokenImplementation(viewController: viewController, context: context)
    }

    public func provideViewController<VC>(
        intent: TokenIntent<T>,
        customisation: CustomisationBlock<VC>? = nil
    ) -> ViewController? where VC: ViewController {
        if let intent = intent as? UseParentIntent<T> {
            return useParent(token: intent.token)
        }

        guard let intent = intent as? ChangeIntent<T> else { return nil }
        switch intent.intent {
        case let .createSingle(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        case let .createMulti(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        case let .createSplitSingle(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        case let .createSplitMulti(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        }
    }

    private func useParent(token: T) -> ViewController? {
        registry.createViewController(from: token, context: self)
    }

    private func createUI<VC, TD>(
        identifier: String,
        tokenData: TD,
        customisation: CustomisationBlock<VC>? = nil
    ) -> MadogUIContainer<T>? where TD: TokenData {
        delegate?.createUI(identifier: identifier, tokenData: tokenData, isModal: false, customisation: customisation)
    }
}
