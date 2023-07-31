//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct MultiUITokenData<T>: TokenData {
    public let intents: [TokenIntent<T>]
}

public extension TokenData {
    static func multi<T>(_ tokens: [T]) -> MultiUITokenData<T> {
        let intents = tokens.map { TokenIntent<T>.useParent($0) }
        return multi(intents)
    }

    static func multi<T>(_ tokens: T...) -> MultiUITokenData<T> {
        multi(tokens)
    }

    static func multi<T>(_ intents: [TokenIntent<T>]) -> MultiUITokenData<T> {
        .init(intents: intents)
    }

    static func multi<T>(_ intents: TokenIntent<T>...) -> MultiUITokenData<T> {
        .init(intents: intents)
    }
}

public typealias AnyMultiContainerFactory<T> = any MultiContainerFactory<T>
public protocol MultiContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> MadogUIContainer<T>?
}
