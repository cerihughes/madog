//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let window = UIWindow()
    private let madog = Madog<SampleToken>.withDefaultContainers()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        madog.resolve(resolver: SampleResolver(), launchOptions: launchOptions)
        window.makeKeyAndVisible()

        let initial = SampleToken.login
        let container = madog.legacy_renderUI(identifier: .splitSingle(), tokenData: .splitSingle(initial), in: window)
        return container != nil
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let currentContainer = madog.currentContainer else { return false }

        let token = SampleToken.vc2(String(url.absoluteString.count))
        if let forwardBack = currentContainer.forwardBack {
            return forwardBack.legacy_navigateForward(token: token, animated: true)
        } else {
            return currentContainer.legacy_change(to: .navigation(), tokenData: .single(token)) != nil
        }
    }
}

private extension Madog {
    func legacy_renderUI<TD, VC>(
        identifier: ContainerUI<T, TD, VC>.Identifier,
        tokenData: TD,
        in window: Window
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        try? renderUI(identifier: identifier, tokenData: tokenData, in: window)
    }
}

private extension Container {
    func legacy_change<TD2, VC2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2
    ) -> AnyContainer<T>? where VC2: ViewController, TD2: TokenData {
        try? change(to: identifier, tokenData: tokenData)
    }
}

private extension ForwardBackContainer {
    func legacy_navigateForward(token: T, animated: Bool) -> Bool {
        do {
            try navigateForward(token: token, animated: animated)
            return true
        } catch {
            return false
        }
    }
}
