//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import XCTest

@testable import MadogContainers_iOS

class TabBarUITests: MadogKIFTestCase {
    private var container: AnyContainer<String>!

    override func afterEach() {
        container = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        container = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertNil(container.forwardBack)
    }

    func testRenderInitialUI() {
        container = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(container.multi?.selectedIndex, 0)
        XCTAssertNotNil(container)
    }

    private func renderUIAndAssert(tokens: String ...) -> AnyContainer<String>? {
        let container = renderUIAndWait(identifier: .tabBar(), tokenData: .multi(tokens))
        tokens.forEach { waitForTitle(token: $0) }
        waitForLabel(token: tokens.first!)
        return container
    }
}
