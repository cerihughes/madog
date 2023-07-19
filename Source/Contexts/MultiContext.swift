//
//  MultiContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyMultiContext<Token> = any MultiContext<Token>

public protocol MultiContext<Token>: Context {
    var selectedIndex: Int { get set }
}
