//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class NavigationUI<Token>: MadogNavigatingModalUIContainer<Token> {
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<Token>, token: Token) {
        super.init(registry: registry, viewController: navigationController)

        guard let viewController = registry.createViewController(from: token) else {
            return nil
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}
