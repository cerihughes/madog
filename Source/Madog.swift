//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias NavigationUIContext<Token> = ModalContext<Token> & ForwardBackNavigationContext<Token>
public typealias TabBarUIContext<Token> = ModalContext<Token> & MultiContext<Token>
public typealias TabBarNavigationUIContext<Token> = TabBarUIContext<Token> & ForwardBackNavigationContext<Token>

public typealias AnyNavigationUIContext<Token> = any NavigationUIContext<Token>
public typealias AnyTabBarUIContext<Token> = any TabBarUIContext<Token>
public typealias AnyTabBarNavigationUIContext<Token> = any TabBarNavigationUIContext<Token>

public final class Madog<Token>: MadogUIContainerDelegate {
    private let registry = RegistryImplementation<Token>()
    private let registrar: Registrar<Token>
    private let factory: MadogUIContainerFactory<Token>

    private var currentContainer: MadogUIContainer<Token>?
    private var modalContainers = [UIViewController: AnyContext<Token>]()

    public init() {
        registrar = Registrar(registry: registry)
        factory = MadogUIContainerFactory<Token>(registry: registry)
    }

    public func resolve(resolver: AnyResolver<Token>, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: String,
        function: @escaping SingleVCUIRegistryFunction<Token>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: String,
        function: @escaping MultiVCUIRegistryFunction<Token>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: String,
        function: @escaping SplitSingleVCUIRegistryFunction<Token>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: String,
        function: @escaping SplitMultiVCUIRegistryFunction<Token>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func renderUI<VC, C>(
        identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        in window: UIWindow,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> C? where VC: UIViewController, C: Context<Token> {
        guard let thing = createUI(
            identifier: identifier,
            tokenData: tokenData,
            isModal: false,
            customisation: customisation
        ) else {
            return nil
        }
        window.setRootViewController(thing.container.viewController, transition: transition)
        return thing.context
    }

    public var currentContext: AnyContext<Token>? {
        currentContainer
    }

    public var serviceProviders: [String: ServiceProvider] {
        registrar.serviceProviders
    }

    // MARK: - MadogUIContainerDelegate

    func createUI<VC, C>(
        identifier: MadogUIIdentifier<VC, C, Token>,
        tokenData: TokenData<Token>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> DelegateThing<Token, C>? where VC: UIViewController, C: Context<Token> {
        guard
            let thing = factory.createUIThing(identifier: identifier, tokenData: tokenData),
            case let container = thing.container,
            let viewController = thing.container.viewController as? VC
        else {
            return nil
        }

        container.delegate = self
        persist(container: container, isModal: isModal)

        customisation?(viewController)
        return thing
    }

    func context(for viewController: UIViewController) -> AnyContext<Token>? {
        if viewController == currentContainer?.viewController {
            return currentContainer
        }
        return modalContainers[viewController]
    }

    func releaseContext(for viewController: UIViewController) {
        if viewController == currentContainer?.viewController {
            currentContainer = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: MadogUIContainer<Token>, isModal: Bool) {
        if isModal {
            modalContainers[container.viewController] = container
        } else {
            currentContainer = container
            modalContainers = [:] // Clear old modal contexts
        }
    }
}

extension UIWindow {
    func setRootViewController(_ viewController: UIViewController, transition: Transition?) {
        rootViewController = viewController

        if let transition = transition {
            UIView.transition(with: self, duration: transition.duration, options: transition.options, animations: {})
        }
    }
}
