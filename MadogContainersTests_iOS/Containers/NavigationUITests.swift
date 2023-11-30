//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import MadogCoreTestUtilities
import XCTest

class NavigationUITests: ContainersKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testProtocolConformance() throws {
        container = try renderUIAndAssert(token: "vc1")
        XCTAssertNil(container.multi)
    }

    func testRenderInitialUI() throws {
        container = try renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(container)
    }

    func testNavigateForwardAndBack() throws {
        container = try renderUIAndAssert(token: "vc1")
        try navigateForwardAndAssert(token: "vc2")

        try container.forwardBack?.navigateBack(animated: true)
        waitForLabel(token: "vc1")
        waitForAbsenceOfTitle(token: "vc2")
    }

    func testBackToRoot() throws {
        container = try renderUIAndAssert(token: "vc1")

        try navigateForwardAndAssert(token: "vc2")
        waitForAbsenceOfLabel(token: "vc1")

        try navigateForwardAndAssert(token: "vc3")
        waitForAbsenceOfLabel(token: "vc2")
        waitForAbsenceOfTitle(token: "vc1") // "Back" no longer shows "vc1"

        try container.forwardBack?.navigateBackToRoot(animated: true)
        waitForTitle(token: "vc1")
        waitForLabel(token: "vc1")
    }

    func testOpenNavigationModal() throws {
        container = try renderUIAndAssert(token: "vc1")

        let modalToken = try container.modal?.openModal(
            identifier: .navigation(),
            tokenData: .single("vc2"),
            presentationStyle: .formSheet,
            animated: true
        )
        waitForTitle(token: "vc2")
        waitForLabel(token: "vc2")

        let modalContainer = modalToken?.container
        let forwardBack = modalContainer?.forwardBack

        try forwardBack?.navigateForward(token: "vc3", animated: true)
        waitForTitle(token: "vc3")
        waitForLabel(token: "vc3")
        waitForAbsenceOfLabel(token: "vc2")

        try forwardBack?.navigateForward(token: "vc4", animated: true)
        waitForTitle(token: "vc4")
        waitForLabel(token: "vc4")
        waitForAbsenceOfTitle(token: "vc2") // "Back" no longer shows "vc2"
    }

    private func renderUIAndAssert(token: String) throws -> AnyContainer<String> {
        let container = try renderUIAndWait(identifier: .navigation(), tokenData: .single(token))
        waitForTitle(token: token)
        waitForLabel(token: token)
        return container
    }

    private func navigateForwardAndAssert(token: String) throws {
        try container?.forwardBack?.navigateForward(token: token, animated: true)
        waitForTitle(token: token)
        waitForLabel(token: token)
        waitForAnimationsToFinish()
    }
}
