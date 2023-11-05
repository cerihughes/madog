//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import MadogCore

class SplitMultiUITests: MadogKIFTestCase {
    private var context: AnySplitMultiContext<String>!

    override func afterEach() {
        context = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert("vc1", ["vc2", "vc3"])
        XCTAssertNil(context as? AnyForwardBackNavigationContext<String>)
        XCTAssertNil(context as? AnyMultiContext<String>)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert("vc1", ["vc2", "vc3"])
        XCTAssertNotNil(context)
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
        context = renderUIAndAssert("vc1", [])
        XCTAssertNotNil(context)
        waitForLabel(token: "vc1")

        context.showDetail(tokens: ["vc2", "vc3"])
        waitForLabel(token: "vc3")
    }

    private func renderUIAndAssert(_ token: String, _ tokens: [String]) -> AnySplitMultiContext<String>? {
        let context = renderUIAndWait(identifier: .splitMulti(), tokenData: .splitMulti(token, tokens))
        waitForAbsenceOfTitle(token: token) // There should be no "Back" titles
        waitForLabel(token: token)
        return context
    }
}
