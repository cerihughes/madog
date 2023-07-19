//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias SingleVCUIRegistryFunction<Token> = (AnyRegistry<Token>, Token) -> MadogModalUIContainer<Token>?
public typealias MultiVCUIRegistryFunction<Token> = (AnyRegistry<Token>, [Token]) -> MadogModalUIContainer<Token>?
public typealias SplitSingleVCUIRegistryFunction<Token> = (AnyRegistry<Token>, Token, Token) -> MadogModalUIContainer<Token>?
public typealias SplitMultiVCUIRegistryFunction<Token> = (AnyRegistry<Token>, Token, [Token]) -> MadogModalUIContainer<Token>?

class MadogUIContainerFactory<Token> {
    private let registry: RegistryImplementation<Token>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<Token>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<Token>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<Token>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<Token>]()

    init(registry: RegistryImplementation<Token>) {
        self.registry = registry

        _ = addUICreationFunction(identifier: basicIdentifier, function: BasicUI.init(registry:token:))
        _ = addUICreationFunction(identifier: navigationIdentifier, function: NavigationUI.init(registry:token:))
        _ = addUICreationFunction(identifier: tabBarIdentifier, function: TabBarUI.init(registry:tokens:))
        _ = addUICreationFunction(identifier: tabBarNavigationIdentifier, function: TabBarNavigationUI.init(registry:tokens:))
    }

    func addUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<Token>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else {
            return false
        }
        singleVCUIRegistry[identifier] = function
        return true
    }

    func addUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<Token>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else {
            return false
        }
        multiVCUIRegistry[identifier] = function
        return true
    }

    func addUICreationFunction(identifier: String, function: @escaping SplitSingleVCUIRegistryFunction<Token>) -> Bool {
        guard splitSingleVCUIRegistry[identifier] == nil else {
            return false
        }
        splitSingleVCUIRegistry[identifier] = function
        return true
    }

    func addUICreationFunction(identifier: String, function: @escaping SplitMultiVCUIRegistryFunction<Token>) -> Bool {
        guard splitMultiVCUIRegistry[identifier] == nil else {
            return false
        }
        splitMultiVCUIRegistry[identifier] = function
        return true
    }

    func createUI<VC>(
        identifier: MadogUIIdentifier<VC>,
        tokenData: TokenData<Token>
    ) -> MadogModalUIContainer<Token>? where VC: UIViewController {
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
