//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import XCTest

@testable import MadogContainers_iOS

class TabBarUITests: MadogKIFTestCase {
    private var context: AnyMultiContext<String>!

    override func afterEach() {
        context = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertNil(context as? AnyForwardBackNavigationContext<String>)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(context.selectedIndex, 0)
        XCTAssertNotNil(context)
    }

    private func renderUIAndAssert(tokens: String ...) -> AnyMultiContext<String>? {
        let context = madog.renderUI(identifier: .tabBar(), tokenData: .multi(tokens), in: window)
        tokens.forEach { waitForTitle(token: $0) }
        waitForLabel(token: tokens.first!)
        return context
    }
}
