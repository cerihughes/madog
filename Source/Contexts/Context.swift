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

public typealias CustomisationBlock<VC: UIViewController> = (VC) -> Void

public protocol Context: AnyObject {
    @discardableResult
    func close(animated: Bool, completion: (() -> Void)?) -> Bool

    @discardableResult
    func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>,
                                      token: Any,
                                      transition: Transition?,
                                      customisation: CustomisationBlock<VC>?) -> Context?
    @discardableResult
    func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>,
                                      tokens: [Any],
                                      transition: Transition?,
                                      customisation: CustomisationBlock<VC>?) -> Context?
    @discardableResult
    func change<VC: UIViewController>(to identifier: SplitSingleUIIdentifier<VC>,
                                      primaryToken: Any,
                                      secondaryToken: Any,
                                      transition: Transition?,
                                      customisation: CustomisationBlock<VC>?) -> Context?
    @discardableResult
    func change<VC: UIViewController>(to identifier: SplitMultiUIIdentifier<VC>,
                                      primaryToken: Any,
                                      secondaryTokens: [Any],
                                      transition: Transition?,
                                      customisation: CustomisationBlock<VC>?) -> Context?
}

public extension Context {
    @discardableResult
    func close(animated: Bool) -> Bool {
        close(animated: animated, completion: nil)
    }

    @discardableResult
    func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Context? {
        change(to: identifier, token: token, transition: nil, customisation: nil)
    }

    @discardableResult
    func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Context? {
        change(to: identifier, tokens: tokens, transition: nil, customisation: nil)
    }
}
