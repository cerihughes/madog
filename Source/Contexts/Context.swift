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

public protocol Context: AnyObject {
    var presentingContext: Context? { get }

    @discardableResult
    func close(animated: Bool, completion: CompletionBlock?) -> Bool

    @discardableResult
    func change<VC, TD>(to identifier: MadogUIIdentifier<VC, TD>,
                        tokenData: TD,
                        transition: Transition?,
                        customisation: CustomisationBlock<VC>?) -> Context? where VC: UIViewController, TD: TokenData
}

public extension Context {
    @discardableResult
    func close(animated: Bool) -> Bool {
        close(animated: animated, completion: nil)
    }

    @discardableResult
    func change<VC, TD>(to identifier: MadogUIIdentifier<VC, TD>,
                        tokenData: TD,
                        transition: Transition? = nil,
                        customisation: CustomisationBlock<VC>? = nil) -> Context? where VC: UIViewController, TD: TokenData {
        change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}
