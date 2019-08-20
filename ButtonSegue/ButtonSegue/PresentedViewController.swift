//
//  PresentedViewController.swift
//  ButtonSegue
//
//  Created by Simon Rofe on 19/8/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {

    var modelObject: String = "" {
        didSet {
            if let label = self.modelLabel {
                label.text = modelObject
            }
        }
    }

    @IBOutlet private(set) weak var modelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelLabel.text = modelObject
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(">> PresentedViewController - init")
    }

    deinit {
        print(">> PresentedViewController - deinit")
    }
}
