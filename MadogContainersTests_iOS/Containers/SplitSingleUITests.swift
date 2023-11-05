//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import MadogCore

class SplitSingleUITests: MadogKIFTestCase {
    private var context: AnySplitSingleContext<String>!

    override func afterEach() {
        context = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert("vc1", "vc2")
        XCTAssertNil(context as? AnyForwardBackNavigationContext<String>)
        XCTAssertNil(context as? AnyMultiContext<String>)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert("vc1", "vc2")
        XCTAssertNotNil(context)
        if isRunningOnIphone {
            waitForAbsenceOfLabel(token: "vc2")
        } else if isRunningOnIpad {
            waitForLabel(token: "vc2")
        }
    }

    func testRenderInitialUI_noSecondary() {
        context = renderUIAndAssert("vc1")
        XCTAssertNotNil(context)
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testShowDetail() {
        context = renderUIAndAssert("vc1")
        XCTAssertNotNil(context)
        waitForLabel(token: "vc1")

        context.showDetail(token: "vc2")
        waitForLabel(token: "vc2")
    }

    private func renderUIAndAssert(_ token1: String, _ token2: String? = nil) -> AnySplitSingleContext<String>? {
        let context = renderUIAndWait(identifier: .splitSingle(), tokenData: .splitSingle(token1, token2))
        waitForAbsenceOfTitle(token: token1) // There should be no "Back" titles
        waitForLabel(token: token1)
        return context
    }
}
