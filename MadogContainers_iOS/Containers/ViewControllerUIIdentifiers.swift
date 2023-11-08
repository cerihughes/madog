//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import MadogCore
import UIKit

public extension ContainerUI.Identifier where VC == BasicUIContainerViewController, TD == SingleUITokenData<T> {
    static func basic() -> Self { .init("basicIdentifier") }
}

public extension ContainerUI.Identifier where VC == UINavigationController, TD == SingleUITokenData<T> {
    static func navigation() -> Self { .init("navigationIdentifier") }
}

public extension ContainerUI.Identifier where VC == UITabBarController, TD == MultiUITokenData<T> {
    static func tabBar() -> Self { .init("tabBarIdentifier") }
    static func tabBarNavigation() -> Self { .init("tabBarNavigationIdentifier") }
}

public extension ContainerUI.Identifier where VC == UISplitViewController, TD == SplitSingleUITokenData<T> {
    static func splitSingle() -> Self { .init("splitViewControllerIdentifier") }
}

public extension ContainerUI.Identifier where VC == UISplitViewController, TD == SplitMultiUITokenData<T> {
    static func splitMulti() -> Self { .init("splitMultiViewControllerIdentifier") }
}

public extension Madog {
    func registerDefaultContainers() {
        _ = addContainerUIFactory(identifier: .basic(), factory: BasicContainerUI.Factory())
        _ = addContainerUIFactory(identifier: .navigation(), factory: BasicNavigatingContainerUI.Factory())
        _ = addContainerUIFactory(identifier: .tabBar(), factory: TabBarContainerUI.Factory())
        _ = addContainerUIFactory(identifier: .tabBarNavigation(), factory: TabBarNavigatingContainerUI.Factory())
        _ = addContainerUIFactory(identifier: .splitSingle(), factory: SplitSingleContainerUI.Factory())
        _ = addContainerUIFactory(identifier: .splitMulti(), factory: SplitMultiContainerUI.Factory())
    }
}
