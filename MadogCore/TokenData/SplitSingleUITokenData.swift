//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitSingleUITokenData<T>: TokenData {
    public let primaryIntent: TokenIntent<T>
    public let secondaryIntent: TokenIntent<T>?
}

public extension TokenData {
    static func splitSingle<T>(
        _ primaryToken: T,
        _ secondaryToken: T? = nil
    ) -> SplitSingleUITokenData<T> {
        let secondaryIntent = secondaryToken.map { TokenIntent<T>.useParent($0) }
        return splitSingle(.useParent(primaryToken), secondaryIntent)
    }

    static func splitSingle<T>(
        _ primaryIntent: TokenIntent<T>,
        _ secondaryIntent: TokenIntent<T>? = nil
    ) -> SplitSingleUITokenData<T> {
        .init(primaryIntent: primaryIntent, secondaryIntent: secondaryIntent)
    }
}

public typealias AnySplitSingleContainerFactory<T> = any SplitSingleContainerFactory<T>
public protocol SplitSingleContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> MadogUIContainer<T>?
}
