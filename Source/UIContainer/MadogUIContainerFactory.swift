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

    func createUI<TD>(
        identifier: MadogUIIdentifier<some UIViewController, some Context<T>, TD, T>,
        tokenData: TD
    ) -> MadogUIContainer<T>? where TD: TokenData<T> {
        if let td = tokenData as? SingleUITokenData<T> {
            return singleVCUIRegistry[identifier.value]?(registry, td.token)
        }
        if let td = tokenData as? MultiUITokenData<T> {
            return multiVCUIRegistry[identifier.value]?(registry, td.tokens)
        }
        if let td = tokenData as? SplitSingleUITokenData<T> {
            return splitSingleVCUIRegistry[identifier.value]?(registry, td.primaryToken, td.secondaryToken)
        }
        if let td = tokenData as? SplitMultiUITokenData<T> {
            return splitMultiVCUIRegistry[identifier.value]?(registry, td.primaryToken, td.secondaryTokens)
        }
        return nil
    }
}
