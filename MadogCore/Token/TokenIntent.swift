//
//  Created by Ceri Hughes on 25/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public struct TokenIntent<VC, C, T> where VC: ViewController {
    let internalIntent: InternalTokenIntent<VC, C, T>
}

public extension TokenIntent {
    static func useParent(_ token: T) -> TokenIntent {
        .init(internalIntent: InternalTokenIntent.parent(token))
    }

    static func create(
        identifier: MadogUIIdentifier<VC, C, SingleUITokenData<VC, C, T>, T>,
        tokenData: SingleUITokenData<VC, C, T>
    ) -> TokenIntent {
        .init(internalIntent: .single(identifier, tokenData))
    }

    static func create(
        identifier: MadogUIIdentifier<VC, C, MultiUITokenData<VC, C, T>, T>,
        tokenData: MultiUITokenData<VC, C, T>
    ) -> TokenIntent {
        .init(internalIntent: .multi(identifier, tokenData))
    }

    static func create(
        identifier: MadogUIIdentifier<VC, C, SplitSingleUITokenData<VC, C, T>, T>,
        tokenData: SplitSingleUITokenData<VC, C, T>
    ) -> TokenIntent {
        .init(internalIntent: .splitSingle(identifier, tokenData))
    }

    static func create(
        identifier: MadogUIIdentifier<VC, C, SplitMultiUITokenData<VC, C, T>, T>,
        tokenData: SplitMultiUITokenData<VC, C, T>
    ) -> TokenIntent {
        .init(internalIntent: .splitMulti(identifier, tokenData))
    }
}

indirect enum InternalTokenIntent<VC, C, T> where VC: ViewController {
    case parent(T)
    case single(MadogUIIdentifier<VC, C, SingleUITokenData<VC, C, T>, T>, SingleUITokenData<VC, C, T>)
    case multi(MadogUIIdentifier<VC, C, MultiUITokenData<VC, C, T>, T>, MultiUITokenData<VC, C, T>)
    case splitSingle(MadogUIIdentifier<VC, C, SplitSingleUITokenData<VC, C, T>, T>, SplitSingleUITokenData<VC, C, T>)
    case splitMulti(MadogUIIdentifier<VC, C, SplitMultiUITokenData<VC, C, T>, T>, SplitMultiUITokenData<VC, C, T>)
}
