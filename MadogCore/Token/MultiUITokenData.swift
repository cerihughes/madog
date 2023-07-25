//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct MultiUITokenData<VC, C, T>: TokenData where VC: ViewController {
    public let intents: [TokenIntent<VC, C, T>]
}

public extension TokenData {
    static func multi<VC, C, T>(_ tokens: [T]) -> MultiUITokenData<VC, C, T> {
        let intents = tokens.map { TokenIntent<VC, C, T>.useParent($0) }
        return multi(intents)
    }

    static func multi<VC, C, T>(_ intents: [TokenIntent<VC, C, T>]) -> MultiUITokenData<VC, C, T> {
        .init(intents: intents)
    }
}
