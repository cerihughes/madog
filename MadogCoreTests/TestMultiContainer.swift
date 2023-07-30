//
//  Created by Ceri Hughes on 30/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

class TestMultiContainer<T>: MadogUIContainer<T>, MultiContext {
    var contentViewControllers = [ViewController]()

    init(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) {
        super.init(registry: registry, viewController: ViewController())

        let viewControllers = tokenData.intents.compactMap { provideViewController(intent: $0) }

        contentViewControllers = viewControllers
    }

    // MARK: - MultiContext

    var selectedIndex: Int = 0 {
        didSet {
            selectedIndex = min(selectedIndex, contentViewControllers.count)
        }
    }
}

struct TestMultiContainerFactory<T>: MultiContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> MadogUIContainer<T>? {
        TestMultiContainer(registry: registry, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == ViewController, C == AnyMultiContext<T>, TD == MultiUITokenData<T> {
    static func testMulti() -> Self { MadogUIIdentifier("testMultiIdentifier") }
}
