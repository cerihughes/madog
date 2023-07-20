//
//  Context.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public struct Transition {
    public let duration: TimeInterval
    public let options: UIView.AnimationOptions

    public init(duration: TimeInterval, options: UIView.AnimationOptions) {
        self.duration = duration
        self.options = options
    }
}

public typealias CompletionBlock = () -> Void
public typealias CustomisationBlock<VC> = (VC) -> Void where VC: UIViewController
public typealias AnyContext<Token> = any Context<Token>

public protocol Context<Token>: AnyObject {
    associatedtype Token

    var presentingContext: AnyContext<Token>? { get }

    @discardableResult
    func close(animated: Bool, completion: CompletionBlock?) -> Bool

    @discardableResult
    func change<VC, C>(
        to identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: UIViewController, C: Context<Token>
}

public extension Context {
    @discardableResult
    func close(animated: Bool) -> Bool {
        close(animated: animated, completion: nil)
    }

    @discardableResult
    func change<VC, C>(
        to identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> C? where VC: UIViewController, C: Context<Token> {
        change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}
