//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class MadogUIContainerFactory<T> {
    private let registry: RegistryImplementation<T>
    private var singleRegistry = [String: Madog<T>.SingleUIFunction]()
    private var multiRegistry = [String: Madog<T>.MultiUIFunction]()
    private var splitSingleRegistry = [String: Madog<T>.SplitSingleUIFunction]()
    private var splitMultiRegistry = [String: Madog<T>.SplitMultiUIFunction]()

    init(registry: RegistryImplementation<T>) {
        self.registry = registry
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, SingleUITokenData<T>, T>,
        function: @escaping Madog<T>.SingleUIFunction
    ) -> Bool {
        guard singleRegistry[identifier.value] == nil else { return false }
        singleRegistry[identifier.value] = function
        return true
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, MultiUITokenData<T>, T>,
        function: @escaping Madog<T>.MultiUIFunction
    ) -> Bool {
        guard multiRegistry[identifier.value] == nil else { return false }
        multiRegistry[identifier.value] = function
        return true
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, SplitSingleUITokenData<T>, T>,
        function: @escaping Madog<T>.SplitSingleUIFunction
    ) -> Bool {
        guard splitSingleRegistry[identifier.value] == nil else { return false }
        splitSingleRegistry[identifier.value] = function
        return true
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, SplitMultiUITokenData<T>, T>,
        function: @escaping Madog<T>.SplitMultiUIFunction
    ) -> Bool {
        guard splitMultiRegistry[identifier.value] == nil else { return false }
        splitMultiRegistry[identifier.value] = function
        return true
    }

    func createUI<TD, C>(
        identifier: MadogUIIdentifier<some ViewController, C, TD, T>,
        tokenData: TD
    ) -> MadogUIContainer<T>? where TD: TokenData {
        if let td = tokenData as? SingleUITokenData<T> {
            return singleRegistry[identifier.value]?(registry, td.intent.token)
        }
        if let td = tokenData as? MultiUITokenData<T> {
            let tokens = td.intents.map { $0.token }
            return multiRegistry[identifier.value]?(registry, tokens)
        }
        if let td = tokenData as? SplitSingleUITokenData<T> {
            return splitSingleRegistry[identifier.value]?(registry, td.primaryIntent.token, td.secondaryIntent?.token)
        }
        if let td = tokenData as? SplitMultiUITokenData<T> {
            let secondaryTokens = td.secondaryIntents.map { $0.token }
            return splitMultiRegistry[identifier.value]?(registry, td.primaryIntent.token, secondaryTokens)
        }
        return nil
    }
}
