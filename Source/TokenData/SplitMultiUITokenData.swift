//
//  SplitMultiUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    public let primaryToken: T
    public let secondaryTokens: [T]

    public init(_ primaryToken: T, _ secondaryTokens: [T]) {
        self.primaryToken = primaryToken
        self.secondaryTokens = secondaryTokens
    }
}
