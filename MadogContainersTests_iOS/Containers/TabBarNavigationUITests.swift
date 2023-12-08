//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import MadogCoreTestUtilities
import XCTest

class TabBarNavigationUITests: ContainersKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testRenderInitialUI() {
        container = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(container.multi?.selectedIndex, 0)
        XCTAssertNotNil(container)
    }

    func testNavigateForwardAndBack() {
        container = renderUIAndAssert(tokens: "vc1", "vc2")

        navigateForwardAndAssert(token: "vc3")
        waitForAbsenceOfLabel(token: "vc1")

        container.forwardBack?.navigateBack(animated: true)
        waitForAbsenceOfLabel(token: "vc3")
        waitForLabel(token: "vc1")
    }

    func testBackToRoot() {
        container = renderUIAndAssert(tokens: "vc1", "vc2")

        navigateForwardAndAssert(token: "vc3")
        waitForAbsenceOfLabel(token: "vc1")

        navigateForwardAndAssert(token: "vc4")
        waitForAbsenceOfLabel(token: "vc3")

        container.forwardBack?.navigateBackToRoot(animated: true)
        waitForAbsenceOfLabel(token: "vc4")
        waitForLabel(token: "vc1")
    }

    func testNavigateForwardAndBack_multitab() {
        container = renderUIAndAssert(tokens: "vc1", "vc2")
        navigateForwardAndAssert(token: "vc3")

        container.multi?.selectedIndex = 1
        waitForAbsenceOfLabel(token: "vc3")
        waitForLabel(token: "vc2")

        navigateForwardAndAssert(token: "vc4")
        waitForAbsenceOfLabel(token: "vc2")
        waitForLabel(token: "vc4")

        container.forwardBack?.navigateBack(animated: true)
        waitForAbsenceOfLabel(token: "vc4")
        waitForLabel(token: "vc2")
    }

    func testOpenMultiNavigationModal() {
        container = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container)

        let modalToken = container.modal!.openModal(
            identifier: .tabBarNavigation(),
            tokenData: .multi("vc2", "vc3"),
            presentationStyle: .formSheet,
            animated: true
        )!
        waitForTitle(token: "vc2")
        waitForLabel(token: "vc2")
        waitForTitle(token: "vc3")
        waitForAbsenceOfLabel(token: "vc3")

        let modalContainer = modalToken.container
        XCTAssertNotNil(modalContainer)

        modalContainer.forwardBack?.navigateForward(token: "vc4", animated: true)
        waitForTitle(token: "vc4")
        waitForLabel(token: "vc4")

        modalContainer.forwardBack?.navigateForward(token: "vc5", animated: true)
        modalContainer.forwardBack?.navigateForward(token: "vc6", animated: true)
        waitForAbsenceOfTitle(token: "vc4") // "Back" no longer shows "vc4"
        waitForTitle(token: "vc5") // "Back" shows "vc5"
        waitForTitle(token: "vc6")
        waitForLabel(token: "vc6")

        modalContainer.multi?.selectedIndex = 1
        modalContainer.forwardBack?.navigateForward(token: "vc7", animated: true)
        waitForTitle(token: "vc3") // "Back" shows "vc3"
        waitForTitle(token: "vc7")
        waitForLabel(token: "vc7")

        modalContainer.forwardBack?.navigateForward(token: "vc8", animated: true)
        modalContainer.forwardBack?.navigateForward(token: "vc9", animated: true)
        waitForAbsenceOfTitle(token: "vc7") // "Back" no longer shows "vc7"
        waitForTitle(token: "vc8") // "Back" shows "vc8"
        waitForTitle(token: "vc9")
        waitForLabel(token: "vc9")

        modalContainer.multi?.selectedIndex = 0
        waitForAbsenceOfTitle(token: "vc8") // "Back" no longer shows "vc8"
        waitForTitle(token: "vc5") // "Back" shows "vc5"
        waitForTitle(token: "vc6")
        waitForLabel(token: "vc6")
    }

    private func renderUIAndAssert(tokens: String ...) -> AnyContainer<String>? {
        let container = renderUIAndWait(identifier: .tabBarNavigation(), tokenData: .multi(tokens))
        tokens.forEach { waitForTitle(token: $0) }
        waitForLabel(token: tokens.first!)
        return container
    }

    private func navigateForwardAndAssert(token: String) {
        container.forwardBack?.navigateForward(token: token, animated: true)
        waitForLabel(token: token)
    }
}
