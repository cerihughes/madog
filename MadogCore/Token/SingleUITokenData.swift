//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<VC, C, T>: TokenData where VC: ViewController {
    public let intent: TokenIntent<VC, C, T>
}

public extension TokenData {
    static func single<VC, C, T>(_ token: T) -> SingleUITokenData<VC, C, T> {
        single(.useParent(token))
    }

    static func single<VC, C, T>(_ intent: TokenIntent<VC, C, T>) -> SingleUITokenData<VC, C, T> {
        .init(intent: intent)
    }
}
