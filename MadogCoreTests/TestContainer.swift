//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

class TestContainer<T>: MadogModalUIContainer<T> {
    var contentViewController: ViewController?

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: ViewController())

        guard let viewController = provideViewController(intent: tokenData.intent) else { return nil }

        contentViewController = viewController
    }
}

struct TestContainerFactory<T>: SingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> MadogUIContainer<T>? {
        TestContainer(registry: registry, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == ViewController, C == AnyModalContext<T>, TD == SingleUITokenData<T> {
    static func test() -> Self { MadogUIIdentifier("testIdentifier") }
}
