//
//  PresentingViewController.swift
//  ButtonSegue
//
//  Created by Simon Rofe on 19/8/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class PresentingViewController: UIViewController {

    @IBOutlet private(set) weak var buttonToTap: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(">> PresentingViewController - init")
    }

    deinit {
        print(">> PresentingViewController - deinit")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPresented", let presented = segue.destination as? PresentedViewController {
            presented.modelObject = "Prepare for segue called"
        }
    }
}
