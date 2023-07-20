//
//  ViewControllerUIIdentifiers.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit

let basicIdentifier = "basicIdentifier"
let navigationIdentifier = "navigationIdentifier"
let tabBarIdentifier = "tabBarIdentifier"
let tabBarNavigationIdentifier = "tabBarNavigationIdentifier"

public struct MadogUIIdentifier<VC, C, T> where VC: UIViewController, C: Context<T> {
    let value: String

    public init(_ value: String) {
        self.value = value
    }
}

// THIS IS WHERE ALL OF THE TYPE GOODNESS CAN HAPPEN

public extension MadogUIIdentifier where VC == BasicUIContainerViewController, C == BasicUI<T> {
    static func basic() -> Self { MadogUIIdentifier(basicIdentifier) }
}

public extension MadogUIIdentifier where VC == UINavigationController, C == NavigationUI<T> {
    static func navigation() -> Self { MadogUIIdentifier(navigationIdentifier) }
}

public extension MadogUIIdentifier where VC == UITabBarController, C == TabBarUI<T> {
    static func tabBar() -> Self { MadogUIIdentifier(tabBarIdentifier) }
}

public extension MadogUIIdentifier where VC == UITabBarController, C == TabBarNavigationUI<T> {
    static func tabBarNavigation() -> Self { MadogUIIdentifier(tabBarNavigationIdentifier) }
}

#endif
