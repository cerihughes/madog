//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

class TestContainer<T>: MadogModalUIContainer<T> {
    var contentViewController: ViewController?

    init?(registry: AnyRegistry<T>, creationContext: CreationContext<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, creationContext: creationContext, viewController: ViewController())

        guard let viewController = provideViewController(intent: tokenData.intent) else { return nil }

        contentViewController = viewController
    }
}

struct TestContainerFactory<T>: SingleContainerFactory {
    func createContainer(
        registry: AnyRegistry<T>,
        creationContext: MadogUIContainer<T>.CreationContext<T>,
        tokenData: SingleUITokenData<T>
    ) -> MadogUIContainer<T>? {
        TestContainer(registry: registry, creationContext: creationContext, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == ViewController, C == AnyModalContext<T>, TD == SingleUITokenData<T> {
    static func test() -> Self { MadogUIIdentifier("testIdentifier") }
}
