//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogContainers_iOS
import MadogCore
import UIKit

class LoginViewController: UIViewController {
    var authenticator: Authenticator!
    weak var context: AnyContext<SampleToken>?

    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    static func createLoginViewController(
        authenticator: Authenticator,
        context: AnyContext<SampleToken>
    ) -> LoginViewController? {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
        guard let loginViewController = storyboard.instantiateInitialViewController() as? LoginViewController else {
            return nil
        }

        loginViewController.authenticator = authenticator
        loginViewController.context = context
        return loginViewController
    }

    override func viewDidAppear(_: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.fakeLogin()
        }
    }

    private func fakeLogin() {
        usernameField.text = "SomeUsername"
        passwordField.text = "SomePassword123"
        activityIndicator.startAnimating()

        authenticator.login(username: "SomeUsername", password: "SomePassword123") { [weak self] _ in
            self?.fakeNavigate()
        }
    }

    private func fakeNavigate() {
        activityIndicator.stopAnimating()

        let intents: [TokenIntent<UITabBarController, AnyTabBarNavigationUIContext<SampleToken>, SampleToken>] = [
            TokenIntent.useParent(.vc1),
            TokenIntent.useParent(.logout)
        ]
        context?.change(to: .tabBarNavigation(), tokenData: .multi(intents))
    }
}
