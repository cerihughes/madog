//
//  TokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public enum TokenData<Token> {
    case single(Token)
    case multi([Token])
    case splitSingle(Token, Token)
    case splitMulti(Token, [Token])
}
