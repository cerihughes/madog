//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import MadogCoreTestUtilities
import XCTest

class SplitSingleUITests: ContainersKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testProtocolConformance() throws {
        container = try renderUIAndAssert("vc1", "vc2")
        XCTAssertNil(container.forwardBack)
        XCTAssertNil(container.multi)
    }

    func testRenderInitialUI() throws {
        container = try renderUIAndAssert("vc1", "vc2")
        XCTAssertNotNil(container)
        if isRunningOnIphone {
            waitForAbsenceOfLabel(token: "vc2")
        } else if isRunningOnIpad {
            waitForLabel(token: "vc2")
        }
    }

    func testRenderInitialUI_noSecondary() throws {
        container = try renderUIAndAssert("vc1")
        XCTAssertNotNil(container)
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testShowDetail() throws {
        container = try renderUIAndAssert("vc1")
        XCTAssertNotNil(container)
        waitForLabel(token: "vc1")

        try container.splitSingle?.showDetail(token: "vc2")
        waitForLabel(token: "vc2")
    }

    private func renderUIAndAssert(_ token1: String, _ token2: String? = nil) throws -> AnyContainer<String> {
        let container = try renderUIAndWait(identifier: .splitSingle(), tokenData: .splitSingle(token1, token2))
        waitForAbsenceOfTitle(token: token1) // There should be no "Back" titles
        waitForLabel(token: token1)
        return container
    }
}
