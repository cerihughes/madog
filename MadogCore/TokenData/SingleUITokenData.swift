//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<T>: TokenData {
    public let intent: TokenIntent<T>
}

public extension TokenData {
    static func single<T>(_ token: T) -> SingleUITokenData<T> {
        single(.useParent(token))
    }

    static func single<T>(_ intent: TokenIntent<T>) -> SingleUITokenData<T> {
        .init(intent: intent)
    }
}

public typealias AnySingleContainerFactory<T> = any SingleContainerFactory<T>
public protocol SingleContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> MadogUIContainer<T>?
}
