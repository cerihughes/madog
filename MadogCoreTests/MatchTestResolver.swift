//
//  Created by Ceri Hughes on 30/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

class TestMatchResolver: Resolver {
    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestMatchServiceProvider.init(context:)]
    }

    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<String>] {
        [ { TestViewControllerProvider(matchString: "match") } ]
    }
}

private class TestViewControllerProvider: ViewControllerProvider {
    private let matchString: String

    init(matchString: String) {
        self.matchString = matchString
    }

    func createViewController(token: String, context: AnyContext<String>) -> ViewController? {
        if token == matchString {
            return ViewController()
        }

        return nil
    }
}

class TestMatchServiceProvider: ServiceProvider {
    var name = "TestMatchServiceProvider"

    init(context _: ServiceProviderCreationContext) {}
}
