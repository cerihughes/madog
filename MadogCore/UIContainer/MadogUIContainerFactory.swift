//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class MadogUIContainerFactory<T> {
    private let registry: RegistryImplementation<T>
    private var singleRegistry = [String: AnySingleContainerFactory<T>]()
    private var multiRegistry = [String: AnyMultiContainerFactory<T>]()
    private var splitSingleRegistry = [String: AnySplitSingleContainerFactory<T>]()
    private var splitMultiRegistry = [String: AnySplitMultiContainerFactory<T>]()

    init(registry: RegistryImplementation<T>) {
        self.registry = registry
    }

    func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, SingleUITokenData<VC, C, T>, T>,
        factory: AnySingleContainerFactory<T>
    ) -> Bool where VC: ViewController {
        guard singleRegistry[identifier.value] == nil else { return false }
        singleRegistry[identifier.value] = factory
        return true
    }

    func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, MultiUITokenData<VC, C, T>, T>,
        factory: AnyMultiContainerFactory<T>
    ) -> Bool where VC: ViewController {
        guard multiRegistry[identifier.value] == nil else { return false }
        multiRegistry[identifier.value] = factory
        return true
    }

    func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, SplitSingleUITokenData<VC, C, T>, T>,
        factory: AnySplitSingleContainerFactory<T>
    ) -> Bool where VC: ViewController {
        guard splitSingleRegistry[identifier.value] == nil else { return false }
        splitSingleRegistry[identifier.value] = factory
        return true
    }

    func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, SplitMultiUITokenData<VC, C, T>, T>,
        factory: AnySplitMultiContainerFactory<T>
    ) -> Bool where VC: ViewController {
        guard splitMultiRegistry[identifier.value] == nil else { return false }
        splitMultiRegistry[identifier.value] = factory
        return true
    }

    func createUI<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD
    ) -> MadogUIContainer<T>? where VC: ViewController, TD: TokenData {
        if let td = tokenData as? SingleUITokenData<VC, C, T> {
            return singleRegistry[identifier.value]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? MultiUITokenData<VC, C, T> {
            return multiRegistry[identifier.value]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? SplitSingleUITokenData<VC, C, T> {
            return splitSingleRegistry[identifier.value]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? SplitMultiUITokenData<VC, C, T> {
            return splitMultiRegistry[identifier.value]?.createContainer(registry: registry, tokenData: td)
        }
        return nil
    }
}
