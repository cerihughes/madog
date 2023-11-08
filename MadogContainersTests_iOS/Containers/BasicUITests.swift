//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import MadogCore

class BasicUITests: MadogKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        container = renderUIAndAssert(token: "vc1")
        XCTAssertNil(container.forwardBack)
        XCTAssertNil(container.multi)
    }

    func testRenderInitialUI() {
        container = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(container)
    }

    private func renderUIAndAssert(token: String) -> AnyContainer<String>? {
        let container = renderUIAndWait(identifier: .basic(), tokenData: .single(token))
        waitForAbsenceOfTitle(token: token) // There should be no "Back" titles
        waitForLabel(token: token)
        return container
    }
}
