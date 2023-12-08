//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import MadogCoreTestUtilities
import XCTest

class ContainerUITests: ContainersKIFTestCase {
    func testChangeSingleToMulti() {
        let container1 = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container1.castValue)

        let container2 = container1.change(to: .tabBar(), tokenData: .multi("vc2", "vc3"))!
        waitForAbsenceOfLabel(token: "vc1")
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(container2.castValue)
    }

    func testChangeMultiToSingle() {
        let container1 = renderUIAndWait(identifier: .tabBar(), tokenData: .multi("vc1", "vc2"))
        waitForTitle(token: "vc1") // Titles should appear in the tab bar
        waitForTitle(token: "vc2")
        XCTAssertNotNil(container1.castValue)

        let container2 = container1.change(to: .basic(), tokenData: .single("vc3"))!
        waitForAbsenceOfTitle(token: "vc1")
        waitForAbsenceOfTitle(token: "vc2")
        waitForLabel(token: "vc3")
        XCTAssertNotNil(container2.castValue)
    }

    func testOpenMultiUIModal() {
        let container = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = createModal(container: container, tokens: ["vc2", "vc3"]).container
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(modalContainer)
    }

    func testCloseMultiUIModal() {
        let container = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalToken = createModal(container: container, tokens: ["vc2", "vc3"])
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(modalToken)

        XCTAssertTrue(closeModalAndWait(container.modal!, token: modalToken))
        waitForAbsenceOfTitle(token: "vc2")
        waitForAbsenceOfTitle(token: "vc3")
    }

    private func createModal(
        container: AnyContainer<String>,
        tokens: [String]
    ) -> AnyModalToken<String> {
        let openExpectation = expectation(description: "Modal \(tokens) opened")
        let modalToken = openModalAndWait(container.modal!, identifier: .tabBar(), tokenData: .multi(tokens)) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)
        tokens.forEach { waitForTitle(token: $0) }
        return modalToken
    }
}
