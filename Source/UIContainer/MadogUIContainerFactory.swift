//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias SingleVCUIRegistryFunction<T> = (AnyRegistry<T>, T) -> MadogModalUIContainer<T>?
public typealias MultiVCUIRegistryFunction<T> = (AnyRegistry<T>, [T]) -> MadogModalUIContainer<T>?
public typealias SplitSingleVCUIRegistryFunction<T> = (AnyRegistry<T>, T, T) -> MadogModalUIContainer<T>?
public typealias SplitMultiVCUIRegistryFunction<T> = (AnyRegistry<T>, T, [T]) -> MadogModalUIContainer<T>?

class MadogUIContainerFactory<T> {
    private let registry: RegistryImplementation<T>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<T>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<T>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<T>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<T>]()

    init(registry: RegistryImplementation<T>) {
        self.registry = registry

        _ = addUICreationFunction(identifier: basicIdentifier, function: BasicUI.init(registry:token:))
        _ = addUICreationFunction(identifier: navigationIdentifier, function: NavigationUI.init(registry:token:))
        _ = addUICreationFunction(identifier: tabBarIdentifier, function: TabBarUI.init(registry:tokens:))
        _ = addUICreationFunction(
            identifier: tabBarNavigationIdentifier,
            function: TabBarNavigationUI.init(registry:tokens:)
        )
    }

    func addUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<T>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else { return false }
        singleVCUIRegistry[identifier] = function
        return true
    }

    func addUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<T>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else { return false }
        multiVCUIRegistry[identifier] = function
        return true
    }

    func addUICreationFunction(identifier: String, function: @escaping SplitSingleVCUIRegistryFunction<T>) -> Bool {
        guard splitSingleVCUIRegistry[identifier] == nil else { return false }
        splitSingleVCUIRegistry[identifier] = function
        return true
    }

    func addUICreationFunction(identifier: String, function: @escaping SplitMultiVCUIRegistryFunction<T>) -> Bool {
        guard splitMultiVCUIRegistry[identifier] == nil else { return false }
        splitMultiVCUIRegistry[identifier] = function
        return true
    }

    func createUI<VC, C>(
        identifier: MadogUIIdentifier<VC, C, T>,
        tokenData: TokenData<T>
    ) -> MadogUIContainer<T>? where VC: UIViewController, C: Context<T> {
        switch tokenData {
        case .single(let token):
            return singleVCUIRegistry[identifier.value]?(registry, token)
        case .multi(let tokens):
            return multiVCUIRegistry[identifier.value]?(registry, tokens)
        case .splitSingle(let primaryToken, let secondaryToken):
            return splitSingleVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryToken)
        case .splitMulti(let primaryToken, let secondaryTokens):
            return splitMultiVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryTokens)
        }
    }
}
