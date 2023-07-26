//
//  Created by Ceri Hughes on 25/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public class TokenIntent<T> {
    public static func useParent(_ token: T) -> TokenIntent<T> {
        UseParentIntent(token: token)
    }

    public static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, SingleUITokenData<T>, T>,
        tokenData: SingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<T> where VC2: ViewController {
        ChangeIntent(intent: .createSingle(identifier.value, tokenData))
    }

    public static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, MultiUITokenData<T>, T>,
        tokenData: MultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<T> where VC2: ViewController {
        ChangeIntent(intent: .createMulti(identifier.value, tokenData))
    }

    public static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, SplitSingleUITokenData<T>, T>,
        tokenData: SplitSingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<T> where VC2: ViewController {
        ChangeIntent(intent: .createSplitSingle(identifier.value, tokenData))
    }

    public static func create<VC2, C2>(
        identifier: MadogUIIdentifier<VC2, C2, SplitMultiUITokenData<T>, T>,
        tokenData: SplitMultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> TokenIntent<T> where VC2: ViewController {
        ChangeIntent(intent: .createSplitMulti(identifier.value, tokenData))
    }
}

class UseParentIntent<T>: TokenIntent<T> {
    let token: T

    init(token: T) {
        self.token = token
    }
}

class ChangeIntent<T>: TokenIntent<T> {
    let intent: InternalChangeIntent<T>

    init(intent: InternalChangeIntent<T>) {
        self.intent = intent
    }
}

indirect enum InternalChangeIntent<T> {
    case createSingle(String, SingleUITokenData<T>)
    case createMulti(String, MultiUITokenData<T>)
    case createSplitSingle(String, SplitSingleUITokenData<T>)
    case createSplitMulti(String, SplitMultiUITokenData<T>)
}
