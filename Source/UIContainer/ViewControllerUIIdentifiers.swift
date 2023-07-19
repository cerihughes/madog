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

public struct MadogUIIdentifier<VC> where VC: UIViewController {
    let value: String

    public init(_ value: String) {
        self.value = value
    }
}

// THIS IS WHERE ALL OF THE TYPE GOODNESS CAN HAPPEN

public extension MadogUIIdentifier where VC == BasicUIContainerViewController {
    static let basic = MadogUIIdentifier(basicIdentifier)
}

public extension MadogUIIdentifier where VC == UINavigationController {
    static let navigation = MadogUIIdentifier(navigationIdentifier)
}

public extension MadogUIIdentifier where VC == UITabBarController {
    static let tabBar = MadogUIIdentifier(tabBarIdentifier)
    static let tabBarNavigation = MadogUIIdentifier(tabBarNavigationIdentifier)
}

#endif
