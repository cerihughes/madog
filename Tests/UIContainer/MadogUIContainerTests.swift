//
//  MadogUIContainerTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import Madog

class MadogUIContainerTests: KIFTestCase {
	private var window: UIWindow!
	private var madog: Madog<String>!

	override func setUp() {
		super.setUp()

		window = UIWindow()
		window.makeKeyAndVisible()
		madog = Madog()
		madog.resolve(resolver: TestResolver())
	}

	override func tearDown() {
		window = nil
		madog = nil

		super.tearDown()
	}

	func testCloseReleasesMainContext() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		weak var context = madog.renderUI(identifier: identifier, token: "vc1", in: window)
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		context?.close()
		XCTAssertNil(context)
	}

	func testCloseModalReleasesModalContext() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		weak var context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? ModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		weak var modalContext = createModalContext(context: context!, token: "vc2")
		XCTAssertNotNil(modalContext)

		modalContext?.close()
		XCTAssertNotNil(context)
		XCTAssertNil(modalContext)
	}

	func testCloseMainReleasesBothContexts() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		weak var context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? Context & ModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		weak var modalContext = createModalContext(context: context!, token: "vc2")
		XCTAssertNotNil(modalContext)

		context?.close()
		XCTAssertNil(context)
		XCTAssertNil(modalContext)
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
	}

	func testCloseWithNestedContexts() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		weak var context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? Context & ModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		weak var modal1Context = createModalContext(context: context!, token: "vc2") as? ModalContext
		XCTAssertNotNil(modal1Context)

		weak var modal2Context = createModalContext(context: modal1Context!, token: "vc3") as? Context & ModalContext
		XCTAssertNotNil(modal2Context)

		weak var modal3Context = createModalContext(context: modal2Context!, token: "vc4") as? ModalContext
		XCTAssertNotNil(modal3Context)

		XCTAssertTrue(modal2Context!.close()) // Closes modal 2 and 3
		XCTAssertNotNil(context)
		XCTAssertNotNil(modal1Context)
		XCTAssertNil(modal2Context)
		XCTAssertNil(modal3Context)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc4")?.waitForAbsenceOfView()

		context?.close() // Closes main and modal 1
		XCTAssertNil(context)
		XCTAssertNil(modal1Context)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
	}

	func testChangeSingleToMulti() {
		let identifier1 = SingleUIIdentifier.createNavigationControllerIdentifier()
		var context = madog.renderUI(identifier: identifier1, token: "vc1", in: window)
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let identifier2 = MultiUIIdentifier.createTabBarControllerIdentifier()
		context = context?.change(to: identifier2, tokens: ["vc2", "vc3"])
		viewTester().usingLabel("vc1")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc2")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForView()
		XCTAssertNotNil(context)
	}

	func testChangeMultiToSingle() {
		let identifier1 = MultiUIIdentifier.createTabBarControllerIdentifier()
		var context = madog.renderUI(identifier: identifier1, tokens: ["vc1", "vc2"], in: window)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
		XCTAssertNotNil(context)

		let identifier2 = SingleUIIdentifier.createNavigationControllerIdentifier()
		context = context?.change(to: identifier2, token: "vc3")
		viewTester().usingLabel("vc1")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc3")?.waitForView()
		XCTAssertNotNil(context)
	}

	func testOpenModal() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let modalToken = context?.openModal(token: "vc2", presentationStyle: .formSheet, animated: true)
		XCTAssertNotNil(modalToken)
		XCTAssertNil(modalToken?.context)
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
	}

	func testCloseModal() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let modalToken = context?.openModal(token: "vc2", presentationStyle: .formSheet, animated: true)
		XCTAssertNotNil(modalToken)
		viewTester().usingLabel("vc2")?.waitForView()

		XCTAssertTrue(context!.closeModal(token: modalToken!, animated: true))
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
	}

	func testOpenSingleUIModal() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let context2 = createModalContext(context: context!, token: "vc2") as? NavigationModalContext
		XCTAssertNotNil(context2)

		viewTester().usingLabel("vc1")?.waitForView()

		context2?.navigateForward(token: "vc3", animated: true)
		context2?.navigateForward(token: "vc4", animated: true)
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForView()
	}

	func testCloseSingleUIModal() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let modalToken = createModal(context: context!, token: "vc2")
		XCTAssertNotNil(modalToken)

		XCTAssertTrue(context!.closeModal(token: modalToken!, animated: true))
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
	}

	func testOpenMultiUIModal() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		var context2 = createModalContext(context: context!, tokens: ["vc2", "vc3"]) as? NavigationModalMultiContext
		XCTAssertNotNil(context2)

		viewTester().usingLabel("vc1")?.waitForView()
		viewTester().usingLabel("vc2")?.waitForView()
		viewTester().usingLabel("vc3")?.waitForView()

		context2?.navigateForward(token: "vc4", animated: true)
		viewTester().usingLabel("vc4")?.waitForView()

		context2?.navigateForward(token: "vc5", animated: true)
		context2?.navigateForward(token: "vc6", animated: true)
		viewTester().usingLabel("vc4")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc5")?.waitForView()
		viewTester().usingLabel("vc6")?.waitForView()

		context2?.selectedIndex = 1
		context2?.navigateForward(token: "vc7", animated: true)
		viewTester().usingLabel("vc7")?.waitForView()

		context2?.navigateForward(token: "vc8", animated: true)
		context2?.navigateForward(token: "vc9", animated: true)
		viewTester().usingLabel("vc7")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc8")?.waitForView()
		viewTester().usingLabel("vc9")?.waitForView()

		context2?.selectedIndex = 0
		viewTester().usingLabel("vc9")?.waitForAbsenceOfView()
		viewTester().usingLabel("vc6")?.waitForView()
	}

	func testCloseMultiUIModal() {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let context = madog.renderUI(identifier: identifier, token: "vc1", in: window) as? NavigationModalContext
		viewTester().usingLabel("vc1")?.waitForView()
		XCTAssertNotNil(context)

		let modalToken = createModal(context: context!, tokens: ["vc2", "vc3"])
		XCTAssertNotNil(modalToken)
		viewTester().usingLabel("vc2")?.waitForView()

		XCTAssertTrue(context!.closeModal(token: modalToken!, animated: true))
		viewTester().usingLabel("vc2")?.waitForAbsenceOfView()
	}

	private func createModal(context: ModalContext, token: String) -> ModalToken? {
		let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
		let modalToken = context.openModal(identifier: identifier,
										   token: token,
										   presentationStyle: .formSheet,
										   animated: true)
		viewTester().usingLabel(token)?.waitForView()
		return modalToken
	}

	private func createModalContext(context: ModalContext, token: String) -> Context? {
		let modalToken = createModal(context: context, token: token)
		return modalToken?.context
	}

	private func createModal(context: ModalContext, tokens: [String]) -> ModalToken? {
		let identifier = MultiUIIdentifier.createTabBarControllerIdentifier()
		let modalToken = context.openModal(identifier: identifier,
										   tokens: tokens,
										   presentationStyle: .formSheet,
										   animated: true)
		tokens.forEach { viewTester().usingLabel($0)?.waitForView() }

		return modalToken
	}

	private func createModalContext(context: ModalContext, tokens: [String]) -> Context? {
		let modalToken = createModal(context: context, tokens: tokens)
		return modalToken?.context
	}
}

private class TestResolver: Resolver<String> {
	override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<String>] {
		return [
			{ TestViewControllerProvider() }
		]
	}
}

private class TestViewControllerProvider: BaseViewControllerProvider {
	override func createViewController(token: String, context _: Context) -> UIViewController? {
		let viewController = TestViewController()
		viewController.title = token
		viewController.label.text = token
		return viewController
	}
}

private class TestViewController: UIViewController {
	let label = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(label)
	}
}
