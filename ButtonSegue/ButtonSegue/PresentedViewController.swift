//
//  PresentedViewController.swift
//  ButtonSegue
//
//  Created by Simon Rofe on 19/8/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {

    var modelObject: String = ""
    @IBOutlet private(set) weak var modelLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(">> PresentedViewController - init")
    }

    deinit {
        print(">> PresentedViewController - deinit")
    }
}
