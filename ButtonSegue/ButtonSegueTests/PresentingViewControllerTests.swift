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

    func test_viewController_hasButtonToTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "PresentingViewController") as! PresentingViewController
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.buttonToTap, "The view controller shall have a button to tap.")
    }
}
