//
//  ViewControllerPresentSpy.swift
//  SeguesTests
//
//  Created by Simon Rofe on 29/7/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class ViewControllerPresentSpy : NSObject {

    var presentedCount: Int = 0
    var presenting: UIViewController?
    var presented: UIViewController?
    var animated: Bool = false

    override init() {
        super.init()
        let presentNotification = Notification.Name(rawValue: PresentSpyNotification.name)
        NotificationCenter.default.addObserver(self, selector: #selector(viewControllerWasPresented(notification:)), name: presentNotification, object: nil)
        UIViewController.swizzlePresent()
    }

    deinit {
        UIViewController.swizzlePresent()
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func viewControllerWasPresented(notification: Notification) {
        self.presentedCount += 1
        self.presenting = notification.userInfo?[PresentSpyNotification.presentingKey] as? UIViewController
        self.presented = notification.object as? UIViewController
        self.animated = (notification.userInfo?[PresentSpyNotification.animatedKey] as? Bool)!
    }
}
