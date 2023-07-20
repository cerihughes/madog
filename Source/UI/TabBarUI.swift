//
//  TabBarUI.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol TabBarAPI: MultiContext {}

public class TabBarUI<Token>: MadogModalUIContainer<Token>, TabBarAPI {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<Token>, tokens: [Token]) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokens.compactMap { registry.createViewController(from: $0, context: self) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContext

    public var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}
