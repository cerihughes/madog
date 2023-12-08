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
        let container = madog.renderUI(identifier: .splitSingle(), tokenData: .splitSingle(initial, nil), in: window)
        return container != nil
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let currentContainer = madog.currentContainer else { return false }

        let token = SampleToken.vc2(String(url.absoluteString.count))
        if let forwardBack = currentContainer.forwardBack {
            return forwardBack.navigateForward(token: token, animated: true)
        } else {
            return currentContainer.change(to: .navigation(), tokenData: .single(token)) != nil
        }
    }
}
