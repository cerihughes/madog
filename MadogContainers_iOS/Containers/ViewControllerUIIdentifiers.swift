//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import MadogCore
import UIKit

public extension MadogUIIdentifier
where VC == BasicUIContainerViewController, C == AnyContext<T>, TD == SingleUITokenData<T> {
    static func basic() -> Self { MadogUIIdentifier("basicIdentifier") }
}

public extension MadogUIIdentifier
where VC == UINavigationController, C == AnyForwardBackNavigationContext<T>, TD == SingleUITokenData<T> {
    static func navigation() -> Self { MadogUIIdentifier("navigationIdentifier") }
}

public extension MadogUIIdentifier
where VC == UITabBarController, C == AnyMultiContext<T>, TD == MultiUITokenData<T> {
    static func tabBar() -> Self { MadogUIIdentifier("tabBarIdentifier") }
}

public protocol MultiForwardBackNavigationContext<T>: MultiContext, ForwardBackNavigationContext {}
public typealias AnyMultiForwardBackNavigationContext<T> = any MultiForwardBackNavigationContext<T>
public extension MadogUIIdentifier
where VC == UITabBarController, C == AnyMultiForwardBackNavigationContext<T>, TD == MultiUITokenData<T> {
    static func tabBarNavigation() -> Self { MadogUIIdentifier("tabBarNavigationIdentifier") }
}

public extension MadogUIIdentifier
where VC == UISplitViewController, C == AnySplitSingleContext<T>, TD == SplitSingleUITokenData<T> {
    static func splitSingle() -> Self { MadogUIIdentifier("splitViewControllerIdentifier") }
}

public extension MadogUIIdentifier
where VC == UISplitViewController, C == AnySplitMultiContext<T>, TD == SplitMultiUITokenData<T> {
    static func splitMulti() -> Self { MadogUIIdentifier("splitMultiViewControllerIdentifier") }
}

public extension Madog {
    func registerDefaultContainers() {
        _ = addContainerFactory(identifier: .basic(), factory: BasicContainerFactory())
        _ = addContainerFactory(identifier: .navigation(), factory: NavigationContainerFactory())
        _ = addContainerFactory(identifier: .tabBar(), factory: TabBarContainerFactory())
        _ = addContainerFactory(identifier: .tabBarNavigation(), factory: TabBarNavigationContainerFactory())
        _ = addContainerFactory(identifier: .splitSingle(), factory: SplitSingleFactory())
        _ = addContainerFactory(identifier: .splitMulti(), factory: SplitMultiFactory())
    }
}
