//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class LoginViewController: UIViewController {
    var authenticator: Authenticator!
    var container: AnyContainer<SampleToken>!

    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    static func createLoginViewController(
        authenticator: Authenticator,
        container: AnyContainer<SampleToken>
    ) -> LoginViewController? {
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
        guard let loginViewController = storyboard.instantiateInitialViewController() as? LoginViewController else {
            return nil
        }

        loginViewController.authenticator = authenticator
        loginViewController.container = container
        return loginViewController
    }

    override func viewDidAppear(_: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.usernameField.text = "SomeUsername"
            self.passwordField.text = "SomePassword123"
            self.activityIndicator.startAnimating()

            self.authenticator.login(username: "SomeUsername", password: "SomePassword123", completion: { _ in
                self.activityIndicator.stopAnimating()

                let tokens: [SampleToken] = [.vc1, .logout]
                self.container.change(
                    to: .tabBarNavigation(),
                    tokenData: .multi(tokens),
                    transition: .init(duration: 1, options: .transitionFlipFromRight)
                )
            })
        }
    }
}
