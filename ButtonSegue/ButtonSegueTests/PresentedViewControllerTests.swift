//
//  PresentedViewControllerTests.swift
//  ButtonSegueTests
//
//  Created by Simon Rofe on 20/8/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import ButtonSegue

class PresentedViewControllerTests: XCTestCase {

    var sut: PresentedViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "PresentedViewController") as? PresentedViewController
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewController_hasModelLabel() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.modelLabel, "The view controller shall have a label for the model data.")
    }

    func test_viewController_hasModelObject() {
        XCTAssertNotNil(sut.modelObject, "The view controller shall have a model object.")
    }
}
