//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<VC, C, T>: TokenData where VC: ViewController {
    public let primaryIntent: TokenIntent<VC, C, T>
    public let secondaryIntents: [TokenIntent<VC, C, T>]
}

public extension TokenData {
    static func splitMulti<VC, C, T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<VC, C, T> {
        let secondaryIntents = secondaryTokens.map { TokenIntent<VC, C, T>.useParent($0) }
        return splitMulti(.useParent(primaryToken), secondaryIntents)
    }

    static func splitMulti<VC, C, T>(
        _ primaryIntent: TokenIntent<VC, C, T>,
        _ secondaryIntents: [TokenIntent<VC, C, T>]
    ) -> SplitMultiUITokenData<VC, C, T> {
        .init(primaryIntent: primaryIntent, secondaryIntents: secondaryIntents)
    }
}
