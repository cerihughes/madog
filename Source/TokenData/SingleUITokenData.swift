//
//  SingleUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<T>: TokenData {
    public let token: T

    public init(_ token: T) {
        self.token = token
    }
}
