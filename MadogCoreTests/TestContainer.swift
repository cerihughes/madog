//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TestContainer<VC, C, T>: MadogModalUIContainer<T> where VC: ViewController {
    private let containerController = UIViewController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<VC, C, T>) {
        super.init(registry: registry, viewController: containerController)

        guard let viewController = provideViewController(intent: tokenData.intent) else { return nil }

        viewController.willMove(toParent: containerController)

        containerController.addChild(viewController)
        containerController.view.addSubview(viewController.view)
        viewController.view.frame = containerController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: containerController)
    }
}

struct TestContainerFactory<T>: SingleContainerFactory {
    func createContainer<VC, C>(
        registry: AnyRegistry<T>,
        tokenData: SingleUITokenData<VC, C, T>
    ) -> MadogModalUIContainer<T>? where VC: UIViewController {
        TestContainer(registry: registry, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == UIViewController, C == AnyModalContext<T>, TD == SingleUITokenData<VC, C, T> {
    static func test() -> Self { MadogUIIdentifier("testIdentifier") }
}
