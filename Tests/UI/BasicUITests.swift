//
//  BasicUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class BasicUITests: MadogKIFTestCase {
    private var context: AnyContext<String>!

    override func afterEach() {
        context = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? any ForwardBackNavigationContext<String>)
        XCTAssertNil(context as? AnyMultiContext<String>)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    private func renderUIAndAssert(token: String) -> AnyContext<String>? {
        let context = madog.renderUI(identifier: .basic(), tokenData: .single(token), in: window)
        waitForAbsenceOfTitle(token: token) // There should be no "Back" titles
        waitForLabel(token: token)
        return context
    }
}

#endif
