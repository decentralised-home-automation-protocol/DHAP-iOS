//
//  SwitchToggleElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

class SwitchToggleElement: ElementView {
    
    @IBOutlet var label: UILabel!
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        print("switch toggled")
    }
    
}
