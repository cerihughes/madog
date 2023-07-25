//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitSingleUITokenData<VC, C, T>: TokenData where VC: ViewController {
    public let primaryIntent: TokenIntent<VC, C, T>
    public let secondaryIntent: TokenIntent<VC, C, T>?
}

public extension TokenData {
    static func splitSingle<VC, C, T>(_ primaryToken: T, _ secondaryToken: T?) -> SplitSingleUITokenData<VC, C, T> {
        let secondaryIntent = secondaryToken.map { TokenIntent<VC, C, T>.useParent($0) }
        return splitSingle(.useParent(primaryToken), secondaryIntent)
    }

    static func splitSingle<VC, C, T>(
        _ primaryIntent: TokenIntent<VC, C, T>,
        _ secondaryIntent: TokenIntent<VC, C, T>?
    ) -> SplitSingleUITokenData<VC, C, T> {
        .init(primaryIntent: primaryIntent, secondaryIntent: secondaryIntent)
    }
}
