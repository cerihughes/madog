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
        .init(internalIntent: InternalTokenIntent.useParent(token))
    }

    static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, SingleUITokenData<VC2, C2, T>, T>,
        tokenData: SingleUITokenData<VC2, C2, T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<VC2, C2, T> where VC2: ViewController {
        .init(internalIntent: .createSingle(identifier, tokenData, customisation))
    }

    static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, MultiUITokenData<VC2, C2, T>, T>,
        tokenData: MultiUITokenData<VC2, C2, T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<VC2, C2, T> where VC2: ViewController {
        .init(internalIntent: .createMulti(identifier, tokenData, customisation))
    }

    static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, SplitSingleUITokenData<VC2, C2, T>, T>,
        tokenData: SplitSingleUITokenData<VC2, C2, T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<VC2, C2, T> where VC2: ViewController {
        .init(internalIntent: .createSplitSingle(identifier, tokenData, customisation))
    }

    static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, SplitMultiUITokenData<VC2, C2, T>, T>,
        tokenData: SplitMultiUITokenData<VC2, C2, T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<VC2, C2, T> where VC2: ViewController {
        .init(internalIntent: .createSplitMulti(identifier, tokenData, customisation))
    }
}

indirect enum InternalTokenIntent<VC, C, T> where VC: ViewController {
    case useParent(T)
    case createSingle(
        MadogUIIdentifier<VC, C, SingleUITokenData<VC, C, T>, T>,
        SingleUITokenData<VC, C, T>,
        CustomisationBlock<VC>?
    )
    case createMulti(
        MadogUIIdentifier<VC, C, MultiUITokenData<VC, C, T>, T>,
        MultiUITokenData<VC, C, T>,
        CustomisationBlock<VC>?
    )
    case createSplitSingle(
        MadogUIIdentifier<VC, C, SplitSingleUITokenData<VC, C, T>, T>,
        SplitSingleUITokenData<VC, C, T>,
        CustomisationBlock<VC>?
    )
    case createSplitMulti(
        MadogUIIdentifier<VC, C, SplitMultiUITokenData<VC, C, T>, T>,
        SplitMultiUITokenData<VC, C, T>,
        CustomisationBlock<VC>?
    )
}
