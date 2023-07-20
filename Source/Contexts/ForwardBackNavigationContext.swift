//
//  ForwardBackNavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyForwardBackNavigationContext<Token> = any ForwardBackNavigationContext<Token>

public protocol ForwardBackNavigationContext<Token>: Context {

    @discardableResult
    func navigateForward(token: Token, animated: Bool) -> Bool
    @discardableResult
    func navigateBack(animated: Bool) -> Bool
    @discardableResult
    func navigateBackToRoot(animated: Bool) -> Bool
}
