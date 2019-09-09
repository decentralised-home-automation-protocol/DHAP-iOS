//
//  ButtonToggleElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

class ButtonToggleElement: ElementView {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var button: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("button pressed")
    }
    
}
