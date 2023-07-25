//
//  Created by Ceri Hughes on 25/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public struct TokenIntent<T> {
    let internalIntent: InternalTokenIntent<T>
}

public extension TokenIntent {
    static func useParent<T>(_ token: T) -> TokenIntent<T> {
        .init(internalIntent: .useParent(token))
    }

    static func create<VC, C, TD, T>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD
    ) -> TokenIntent where VC: ViewController, TD: TokenData {
        .init(internalIntent: .create(VC.self, C.self, tokenData))
    }
}

enum InternalTokenIntent<T> {
    case useParent(T)
    case create(ViewController.Type, Any.Type, TokenData)
}
