//
//  NSObjectReplaceMethodExtension.swift
//  SeguesTests
//
//  Created by Simon Rofe on 29/7/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

extension NSObject {
    class func replaceInstanceMethod(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        if let om = originalMethod, let sm = swizzledMethod {
            method_exchangeImplementations(om, sm)
        }
    }
}
