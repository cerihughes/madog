//
//  Created by Ceri Hughes on 30/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import MadogCore

class ContainerUITests: XCTestCase {
    private var madog: Madog<String>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestMatchResolver())
        madog.addContainerFactory(identifier: .test(), factory: TestContainerFactory())
        madog.addContainerFactory(identifier: .testMulti(), factory: TestMultiContainerFactory())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testSingleUI() {
        let window = UIWindow()

        let context = madog.renderUI(identifier: .test(), tokenData: .single("match"), in: window)
        let container = context as? TestContainer<String>
        XCTAssertNotNil(container)
        XCTAssertNotNil(container?.contentViewController)
    }

    func testMultiUI() {
        let window = UIWindow()

        let context = madog.renderUI(identifier: .testMulti(), tokenData: .multi("match", "match"), in: window)
        let container = context as? TestMultiContainer<String>
        XCTAssertNotNil(container)
        XCTAssertEqual(container?.contentViewControllers.count, 2)
    }

    func testNestedUI_singleInMulti() {
        let window = UIWindow()

        let intents: [TokenIntent<String>] = [
            .useParent("match"),
            .create(identifier: .test(), tokenData: .single("match"))
        ]

        let context = madog.renderUI(identifier: .testMulti(), tokenData: .multi(intents), in: window)
        let container = context as? TestMultiContainer<String>
        XCTAssertNotNil(container)
        XCTAssertEqual(container?.contentViewControllers.count, 2)
    }

    func testNestedUI_multiInMulti() {
        let window = UIWindow()

        let intents: [TokenIntent<String>] = [
            .useParent("match"),
            .create(identifier: .testMulti(), tokenData: .multi("match", "match"))
        ]

        let context = madog.renderUI(identifier: .testMulti(), tokenData: .multi(intents), in: window)
        let container = context as? TestMultiContainer<String>
        XCTAssertNotNil(container)
        XCTAssertEqual(container?.contentViewControllers.count, 2)
    }
}
