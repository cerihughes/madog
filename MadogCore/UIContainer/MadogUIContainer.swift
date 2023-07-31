//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyMadogUIContainerDelegate<T> = any MadogUIContainerDelegate<T>

protocol MadogUIContainerDelegate<T>: AnyObject {
    associatedtype T

    func createUI<VC, TD>(
        identifier: String,
        tokenData: TD,
        isModal: Bool,
        parentContainerID: Int?,
        customisation: CustomisationBlock<VC>?
    ) -> MadogUIContainer<T>? where VC: ViewController, TD: TokenData

    func context(for viewController: ViewController) -> AnyContext<T>?
    func releaseContext(for viewController: ViewController)
}

open class MadogUIContainer<T>: Context {
    public struct CreationContext<T> {
        let containerID: Int
        weak var delegate: AnyMadogUIContainerDelegate<T>?
    }

    public private(set) var registry: AnyRegistry<T>
    let viewController: ViewController

    private let containerID: Int
    private (set) weak var delegate: AnyMadogUIContainerDelegate<T>?

    public init(registry: AnyRegistry<T>, creationContext: CreationContext<T>, viewController: ViewController) {
        self.registry = registry
        self.viewController = viewController
        containerID = creationContext.containerID
        delegate = creationContext.delegate
    }

    // MARK: - Context

    public var presentingContext: AnyContext<T>? {
        guard let presentingViewController = viewController.presentingViewController else { return nil }
        return delegate?.context(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        // OVERRIDE
        false
    }

    public func change<VC, C, TD>(
        to identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: ViewController, TD: TokenData {
        guard
            let container = delegate?.createUI(
                identifier: identifier.value,
                tokenData: tokenData,
                isModal: false,
                parentContainerID: nil,
                customisation: customisation
            ),
            let window = viewController.resolvedWindow
        else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container as? C
    }

    public func provideViewController<VC>(
        intent: TokenIntent<T>,
        customisation: CustomisationBlock<VC>? = nil
    ) -> ViewController? where VC: ViewController {
        if let intent = intent as? UseParentIntent<T> {
            return useParent(token: intent.token)
        }

        guard let intent = intent as? ChangeIntent<T> else { return nil }
        switch intent.intent {
        case let .createSingle(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        case let .createMulti(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        case let .createSplitSingle(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        case let .createSplitMulti(identifier, tokenData):
            return createUI(identifier: identifier, tokenData: tokenData, customisation: customisation)?.viewController
        }
    }

    private func useParent(token: T) -> ViewController? {
        registry.createViewController(from: token, context: self)
    }

    private func createUI<VC, TD>(
        identifier: String,
        tokenData: TD,
        customisation: CustomisationBlock<VC>? = nil
    ) -> MadogUIContainer<T>? where TD: TokenData {
        delegate?.createUI(
            identifier: identifier,
            tokenData: tokenData,
            isModal: false,
            parentContainerID: containerID,
            customisation: customisation
        )
    }
}

private extension ViewController {
    var resolvedWindow: Window? {
        if #available(iOS 13, *) {
            return view.window
        } else {
            // On iOS12, the window of a modally presenting VC can be nil
            return view.window ?? presentedViewController?.resolvedWindow
        }
    }
}
