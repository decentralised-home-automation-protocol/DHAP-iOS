//
//  StepperElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 10/9/19.
//

import Foundation

class StepperElement: ElementView {

    @IBOutlet var label: UILabel!

    private let value = Int()

    @IBAction func onChange(_ sender: UIStepper) {
        print("onChange")
    }

}
