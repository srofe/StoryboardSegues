//
//  PresentingViewControllerTests.swift
//  ButtonSegueTests
//
//  Created by Simon Rofe on 19/8/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import ButtonSegue

class PresentingViewControllerTests: XCTestCase {

    var sut: PresentingViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "PresentingViewController") as? PresentingViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewController_hasButtonToTap() {
        XCTAssertNotNil(sut.buttonToTap, "The view controller shall have a button to tap.")
    }

    func test_buttonToTap_hasATarget() {
        XCTAssertNotNil(sut.buttonToTap.allTargets.first, "The button to tap shall have at least one target.")
    }

    func test_buttonSegue_hasAnIdentifier() {
        let segue = sut.buttonToTap.allTargets.first?.base
        XCTAssertNotEqual((segue as AnyObject).identifier, "", "The segue from the button shall have an identifier.")
    }

    func test_buttonToTap_onlyRespondsToTouchUpInsideEvent() {
        XCTAssertEqual(sut.buttonToTap.allControlEvents, .touchUpInside, "The button to tap shall only respond to touch up inside events.")
    }

    func test_buttonToTap_hasOnlyOneActionForTouchUpInsideEvent() {
        guard let actions = sut.buttonToTap.actions(forTarget: sut.buttonToTap.allTargets.first, forControlEvent: .touchUpInside) else {
            XCTFail("There should be a target action for the touch up inside event.")
            return
        }
        XCTAssertEqual(actions.count, 1, "There shall only be one target action for the touch up inside event.")
    }
}
