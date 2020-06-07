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
    func change<VC: UIViewController>(to identifier: MadogUIIdentifier<VC>,
                                      tokenHolder: TokenHolder<Any>,
                                      transition: Transition?,
                                      customisation: CustomisationBlock<VC>?) -> Context?
}

public extension Context {
    @discardableResult
    func close(animated: Bool) -> Bool {
        close(animated: animated, completion: nil)
    }

    @discardableResult
    func change<VC: UIViewController>(to identifier: MadogUIIdentifier<VC>,
                                      tokenHolder: TokenHolder<Any>,
                                      transition: Transition? = nil,
                                      customisation: CustomisationBlock<VC>? = nil) -> Context? {
        change(to: identifier, tokenHolder: tokenHolder, transition: transition, customisation: customisation)
    }
}
