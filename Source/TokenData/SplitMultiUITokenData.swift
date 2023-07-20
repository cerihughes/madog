//
//  SplitMultiUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData: TokenData {
    public let primaryToken: Any
    public let secondaryTokens: [Any]

    public init<T>(primaryToken: T, secondaryTokens: [T]) {
        self.primaryToken = primaryToken
        self.secondaryTokens = secondaryTokens
    }
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData {
        SplitMultiUITokenData(primaryToken: primaryToken, secondaryTokens: secondaryTokens)
    }
}
