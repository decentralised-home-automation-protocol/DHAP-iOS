//
//  PasswordElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 14/9/19.
//

import Foundation

class PasswordElement: ElementView {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var submitButton: UIButton!

    @IBAction func submitAction(_ sender: UIButton) {
        print("password submit")
    }
    
}
