//
//  MadogTypesTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 04/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class MadogTypesTests: XCTestCase {
    private var registry: RegistryImplementation<Int>!
    private var registrar: Registrar<Int>!

    override func setUp() {
        super.setUp()

        registry = RegistryImplementation()
        registrar = Registrar(registry: registry)
    }

    override func tearDown() {
        registry = nil
        registrar = nil

        super.tearDown()
    }

    func testMadogResolver() {
        // This mostly tests that the code compiles as expected... Don't need to exercise it much.

        let resolver = TestResolver()
        XCTAssertEqual(resolver.serviceProviderFunctions().count, 1)
        XCTAssertEqual(resolver.viewControllerProviderFunctions().count, 1)

        XCTAssertNil(registry.createViewController(from: 1))
        registrar.resolve(resolver: resolver)
        XCTAssertNotNil(registry.createViewController(from: 0))
    }
}

private class TestViewControllerProvider: ViewControllerProvider {
    typealias T = Int

    func createViewController(token: Int) -> UIViewController? {
        UIViewController()
    }
}

private class TestServiceProvider: ServiceProvider {
    var name = "TestServiceProvider"

    required init(context _: ServiceProviderCreationContext) {}
}

private class TestResolver: Resolver {
    typealias T = Int

    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Int>] {
        [TestViewControllerProvider.init]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestServiceProvider.init(context:)]
    }
}
