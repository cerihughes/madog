//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    public let primaryIntent: TokenIntent<T>
    public let secondaryIntents: [TokenIntent<T>]
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<T> {
        let secondaryIntents = secondaryTokens.map { TokenIntent<T>.useParent($0) }
        return splitMulti(.useParent(primaryToken), secondaryIntents)
    }

    static func splitMulti<T>(
        _ primaryIntent: TokenIntent<T>,
        _ secondaryIntents: [TokenIntent<T>]
    ) -> SplitMultiUITokenData<T> {
        .init(primaryIntent: primaryIntent, secondaryIntents: secondaryIntents)
    }
}

public typealias AnySplitMultiContainerFactory<T> = any SplitMultiContainerFactory<T>
public protocol SplitMultiContainerFactory<T> {
    associatedtype T
    func createContainer(
        registry: AnyRegistry<T>,
        creationContext: MadogUIContainer<T>.CreationContext<T>,
        tokenData: SplitMultiUITokenData<T>
    ) -> MadogUIContainer<T>?
}
