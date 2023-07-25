//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    let primaryIntent: TokenIntent<T>
    let secondaryIntents: [TokenIntent<T>]
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<T> {
        let secondaryIntents = secondaryTokens.map { TokenIntent.useParent($0) }
        return splitMulti(.useParent(primaryToken), secondaryIntents)
    }

    static func splitMulti<T>(
        _ primaryIntent: TokenIntent<T>,
        _ secondaryIntents: [TokenIntent<T>]
    ) -> SplitMultiUITokenData<T> {
        .init(primaryIntent: primaryIntent, secondaryIntents: secondaryIntents)
    }
}
