//
//  ModalContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias AnyModalContext<Token> = any ModalContext<Token>

public protocol ModalContext<Token>: Context {
    associatedtype Token

    // swiftlint:disable function_parameter_count
    @discardableResult
    func openModal<VC>(
        identifier: MadogUIIdentifier<VC>,
        tokenData: TokenData<Token>,
        presentationStyle: UIModalPresentationStyle?,
        transitionStyle: UIModalTransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<Token>? where VC: UIViewController
    // swiftlint:enable function_parameter_count

    @discardableResult
    func closeModal(
        token: AnyModalToken<Token>,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool
}

public extension ModalContext {
    @discardableResult
    func openModal<VC>(
        identifier: MadogUIIdentifier<VC>,
        tokenData: TokenData<Token>,
        presentationStyle: UIModalPresentationStyle? = nil,
        transitionStyle: UIModalTransitionStyle? = nil,
        popoverAnchor: Any? = nil,
        animated: Bool,
        customisation: CustomisationBlock<VC>? = nil,
        completion: CompletionBlock? = nil
    ) -> AnyModalToken<Token>? where VC: UIViewController {
        openModal(
            identifier: identifier,
            tokenData: tokenData,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            customisation: customisation,
            completion: completion
        )
    }

    @discardableResult
    func closeModal(token: AnyModalToken<Token>, animated: Bool) -> Bool {
        closeModal(token: token, animated: animated, completion: nil)
    }
}

public typealias AnyModalToken<Token> = any ModalToken<Token>

public protocol ModalToken<Token> {
    associatedtype Token

    var context: AnyContext<Token> { get }
}

class ModalTokenImplementation<Token>: ModalToken {
    let viewController: UIViewController
    let context: AnyContext<Token>

    init(viewController: UIViewController, context: AnyContext<Token>) {
        self.viewController = viewController
        self.context = context
    }
}
