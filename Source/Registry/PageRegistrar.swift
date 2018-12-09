//
//  PageRegistrar.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// A class that presents view controllers, and manages the navigation between them.
internal class PageRegistrar {
    private let resolver: Resolver
    internal var states = [String:State]()
    internal var pages = [Page]()

    internal init(resolver: Resolver) {
        self.resolver = resolver
    }

    internal func loadState() {
        let stateCreationFunctions = resolver.stateCreationFunctions()
        for stateCreationFunction in stateCreationFunctions {
            let state = stateCreationFunction()
            let name = state.name
            states[name] = state
        }
    }

    internal func registerPages(with registry: ViewControllerRegistry) {
        let pageCreationFunctions = resolver.pageCreationFunctions()
        for pageCreationFunction in pageCreationFunctions {
            let page = pageCreationFunction()
            page.register(with: registry)
            page.configure(with: states)
            pages.append(page)
        }
    }

    internal func unregisterPages(from registry: ViewControllerRegistry) {
        for page in pages {
            page.unregister(from: registry)
        }
        pages.removeAll()
    }
}
