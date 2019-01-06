//
//  RuntimeResolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// An implementation of Resolver which uses objc-runtime magic to find all loaded classes that
/// subclass from ViewControllerProviderObject and ResourceProviderObject respectively.
public final class RuntimeResolver: Resolver {
    private let bundle: Bundle

    private var loadedViewControllerProviderCreationFunctions = [ViewControllerProviderCreationFunction]()
    private var loadedResourceProviderCreationFunctions = [ResourceProviderCreationFunction]()

    convenience public init() {
        self.init(bundle: Bundle.main)
    }

    public init(bundle: Bundle) {
        self.bundle = bundle

        inspectLoadedClasses()
    }

    // MARK: Resolver

    public func viewControllerProviderCreationFunctions() -> [ViewControllerProviderCreationFunction] {
        return loadedViewControllerProviderCreationFunctions
    }

    public func resourceProviderCreationFunctions() -> [ResourceProviderCreationFunction] {
        return loadedResourceProviderCreationFunctions
    }

    // MARK: Private

    private func inspectLoadedClasses() {
        if let executablePath = bundle.executablePath {
            var classCount: UInt32 = 0
            let classNames = objc_copyClassNamesForImage(executablePath, &classCount)
            if let classNames = classNames {
                for i in 0 ..< classCount {
                    let className = classNames[Int(i)]
                    let name = String.init(cString: className)
                    if let cls = NSClassFromString(name) as? ViewControllerProviderObject.Type {
                        loadedViewControllerProviderCreationFunctions.append { return cls.init() }
                    }
                    if let cls = NSClassFromString(name) as? ResourceProviderObject.Type {
                        loadedResourceProviderCreationFunctions.append { context in
                            return cls.init(context: context)
                        }
                    }
                }
            }

            free(classNames);

            // Sort functions alphabetically by description
            loadedViewControllerProviderCreationFunctions.sort { String(describing: $0) < String(describing: $1) }
            loadedResourceProviderCreationFunctions.sort { String(describing: $0) < String(describing: $1) }
        }
    }
}

open class ViewControllerProviderObject: ViewControllerProvider {
    public required init() {}
    open func register(with registry: ViewControllerRegistry) {}
    open func unregister(from registry: ViewControllerRegistry) {}
    open func configure(with resourceProviders: [String : ResourceProvider]) {}
}

open class ResourceProviderObject: ResourceProvider {
    public var name: String = "Default"
    public required init(context: ResourceProviderCreationContext) {}
}
