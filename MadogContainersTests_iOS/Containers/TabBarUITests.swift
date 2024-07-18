//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import MadogCoreTestUtilities
import XCTest

class TabBarUITests: ContainersKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testProtocolConformance() throws {
        container = try renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertNil(container.forwardBack)
    }

    func testRenderInitialUI() throws {
        container = try renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(container.multi?.selectedIndex, 0)
        XCTAssertNotNil(container)
    }

    private func renderUIAndAssert(tokens: String ...) throws -> AnyContainer<String>? {
        let container = try renderUIAndWait(identifier: .tabBar(), tokenData: .multi(tokens))
        tokens.forEach { waitForTitle(token: $0) }
        waitForLabel(token: tokens.first!)
        return container
    }
}
