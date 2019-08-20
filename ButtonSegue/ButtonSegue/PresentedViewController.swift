//
//  PresentedViewController.swift
//  ButtonSegue
//
//  Created by Simon Rofe on 19/8/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(">> PresentedViewController - init")
    }

    deinit {
        print(">> PresentedViewController - deinit")
    }
}
