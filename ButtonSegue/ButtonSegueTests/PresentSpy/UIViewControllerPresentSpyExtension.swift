//
//  UIViewControllerPresentSpyExtension.swift
//  SeguesTests
//
//  Created by Simon Rofe on 29/7/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

struct PresentSpyNotification {
    static let name = "PresentSpyNotification"
    static let presentingKey = "PresentSpyPresentingKey"
    static let animatedKey = "PresentSpyAnimatedKey"
}

extension UIViewController {
    class func swizzlePresent() {
        let originalSelector = #selector(present(_:animated:completion:))
        let swizzledSelector = #selector(swizzledPresent(_:animated:completion:))
        self.replaceInstanceMethod(originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }

    @objc func swizzledPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.loadViewIfNeeded()
        let notificationName = Notification.Name(PresentSpyNotification.name)
        let notification = NotificationCenter.default
        let userInfo: [AnyHashable:Any]? = [
            PresentSpyNotification.presentingKey:self,
            PresentSpyNotification.animatedKey:flag]
        notification.post(name: notificationName, object: viewControllerToPresent, userInfo: userInfo)
        if let completion = completion {
            completion()
        }
    }
}
