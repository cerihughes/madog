//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import MadogContainers_iOS

class MadogCustomisationTests: MadogKIFTestCase {
    func testMainCustomisationBlock() {
        _ = madog.renderUI(
            identifier: .basic(),
            tokenData: .single("vc1"),
            in: window,
            customisation: customise(viewController:)
        )

        waitForTitle(token: "CUSTOMISED")
    }

    func testModalCustomisationBlock() {
        let context = madog.renderUI(identifier: .basic(), tokenData: .single("vc1"), in: window)

        waitForAbsenceOfTitle(token: "CUSTOMISED")
        _ = context?.openModal(
            identifier: .basic(),
            tokenData: .single("vc1"),
            animated: true,
            customisation: customise(viewController:)
        )

        waitForTitle(token: "CUSTOMISED")
    }

    private func customise(viewController: UIViewController) {
        let label = UILabel()
        label.text = "CUSTOMISED"
        viewController.view.addSubview(label)
    }
}

#endif