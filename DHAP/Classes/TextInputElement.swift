//
//  TextInputElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 14/9/19.
//

import Foundation

class TextInputElement: ElementView {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var textInput: UITextField!
    
    @IBOutlet var button: UIButton!
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        print("textInput submitted")
    }
    
}
