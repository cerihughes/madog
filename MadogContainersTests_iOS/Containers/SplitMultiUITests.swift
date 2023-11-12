//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import MadogCoreTestUtilities
import XCTest

@testable import MadogContainers_iOS

class SplitMultiUITests: ContainerKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        container = renderUIAndAssert("vc1", ["vc2", "vc3"])
        XCTAssertNil(container.forwardBack)
        XCTAssertNil(container.multi)
    }

    func testRenderInitialUI() {
        container = renderUIAndAssert("vc1", ["vc2", "vc3"])
        XCTAssertNotNil(container)
        if isRunningOnIphone {
            assertRenderInitialUI_iPhone()
        } else if isRunningOnIpad {
            assertRenderInitialUI_iPad()
        }
    }

    func assertRenderInitialUI_iPhone() {
        waitForAbsenceOfLabel(token: "vc2")
        waitForAbsenceOfLabel(token: "vc3")
    }

    func assertRenderInitialUI_iPad() {
        waitForTitle(token: "vc3")
        waitForLabel(token: "vc1")
        waitForAbsenceOfLabel(token: "vc2")
        waitForLabel(token: "vc3")
    }

    func testShowDetail() {
        container = renderUIAndAssert("vc1", [])
        XCTAssertNotNil(container)
        waitForLabel(token: "vc1")

        container.splitMulti?.showDetail(tokens: ["vc2", "vc3"])
        waitForLabel(token: "vc3")
    }

    private func renderUIAndAssert(_ token: String, _ tokens: [String]) -> AnyContainer<String>? {
        let container = renderUIAndWait(identifier: .splitMulti(), tokenData: .splitMulti(token, tokens))
        waitForAbsenceOfTitle(token: token) // There should be no "Back" titles
        waitForLabel(token: token)
        return container
    }
}
