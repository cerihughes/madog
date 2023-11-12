//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class LoginViewControllerProvider: ViewControllerProvider {
    private var authenticator: Authenticator?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let authenticatorProvider = serviceProviders[authenticatorProviderName] as? AuthenticatorProvider {
            authenticator = authenticatorProvider.authenticator
        }
    }

    func createViewController(token: SampleToken, container: AnyContainer<SampleToken>) -> UIViewController? {
        guard token == .login, let authenticator else { return nil }
        return LoginViewController.createLoginViewController(authenticator: authenticator, container: container)
    }
}
