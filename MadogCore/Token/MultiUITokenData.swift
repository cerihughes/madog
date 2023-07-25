//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct MultiUITokenData<T>: TokenData {
    let intents: [TokenIntent<T>]
}

public extension TokenData {
    static func multi<T>(_ tokens: [T]) -> MultiUITokenData<T> {
        let intents = tokens.map { TokenIntent.useParent($0) }
        return multi(intents)
    }

    static func multi<T>(_ intents: [TokenIntent<T>]) -> MultiUITokenData<T> {
        .init(intents: intents)
    }
}
