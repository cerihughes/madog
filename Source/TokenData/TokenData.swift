//
//  TokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public enum TokenData<T> {
    case single(T)
    case multi([T])
    case splitSingle(T, T)
    case splitMulti(T, [T])
}
