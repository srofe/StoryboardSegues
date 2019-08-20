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

    func test_modelLabel_isSetWhenViewLoaded() {
        sut.modelObject = "Some model object text to show"
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.modelLabel.text, "Some model object text to show", "The model label shall be updated when the view is loaded.")
    }

    func test_modelLable_updatedWhenModelObjectChangedq() {
        sut.modelObject = "Some text"
        sut.loadViewIfNeeded()
        sut.modelObject = "New model text"
        XCTAssertEqual(sut.modelLabel.text, "New model text", "The label text shall be updated when the model data is changed.")
    }
}
