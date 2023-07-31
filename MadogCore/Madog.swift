//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public final class Madog<T>: MadogUIContainerDelegate {
    private let registry = RegistryImplementation<T>()
    private let registrar: Registrar<T>
    private let containerRepository: ContainerRepository<T>

    private var nextContainerID = 0
    private var rootContainer: MadogUIContainer<T>?
    private var nestedContainers = [Int: [MadogUIContainer<T>]]()

    private var modalContainers = [ViewController: AnyContext<T>]()

    public init() {
        registrar = Registrar(registry: registry)
        containerRepository = ContainerRepository<T>(registry: registry)
    }

    public func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, SingleUITokenData<T>, T>,
        factory: AnySingleContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, MultiUITokenData<T>, T>,
        factory: AnyMultiContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, SplitSingleUITokenData<T>, T>,
        factory: AnySplitSingleContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerFactory<VC, C>(
        identifier: MadogUIIdentifier<VC, C, SplitMultiUITokenData<T>, T>,
        factory: AnySplitMultiContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func renderUI<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        in window: Window,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> C? where VC: ViewController, TD: TokenData {
        guard let container = createUI(
            identifier: identifier.value,
            tokenData: tokenData,
            isModal: false,
            parentContainerID: nil,
            customisation: customisation
        ) else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container as? C
    }

    public var rootContext: AnyContext<T>? {
        rootContainer
    }

    public var serviceProviders: [String: ServiceProvider] {
        registrar.serviceProviders
    }

    // MARK: - MadogUIContainerDelegate

    func createUI<VC, TD>(
        identifier: String,
        tokenData: TD,
        isModal: Bool,
        parentContainerID: Int?,
        customisation: CustomisationBlock<VC>?
    ) -> MadogUIContainer<T>? where VC: ViewController, TD: TokenData {
        guard
            let container = containerRepository.createContainer(
                identifier: identifier,
                creationContext: .init(containerID: nextContainerID, delegate: self),
                tokenData: tokenData
            ),
            let viewController = container.viewController as? VC
        else {
            return nil
        }

        nextContainerID += 1

        persist(container: container, parentContainerID: parentContainerID, isModal: isModal)
        customisation?(viewController)
        return container
    }

    func context(for viewController: ViewController) -> AnyContext<T>? {
        if viewController == rootContainer?.viewController { return rootContainer }
        return modalContainers[viewController]
    }

    func releaseContext(for viewController: ViewController) {
        if viewController == rootContainer?.viewController {
            rootContainer = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: MadogUIContainer<T>, parentContainerID: Int?, isModal: Bool) {
        if isModal {
            modalContainers[container.viewController] = container
        } else {
            rootContainer = container
            modalContainers = [:] // Clear old modal contexts

            if let parentContainerID {
                var containers = nestedContainers[parentContainerID] ?? []
                containers.append(container)
                nestedContainers[parentContainerID] = containers
            }
        }
    }
}

extension Window {
    func setRootViewController(_ viewController: ViewController, transition: Transition?) {
        rootViewController = viewController

        if let transition {
            View.transition(with: self, duration: transition.duration, options: transition.options, animations: {})
        }
    }
}
