//
//  GUIElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

public enum GUIElementType: String {
    
    case switchtoggle, buttontoggle, stepper, rangeinput, directionalbuttons, selection, status, textinput, progress, buttongroup, scheduler, password
    
}

public struct GUIElement {
    
    public var type: GUIElementType
    
    public var displaySettings: [String]
    
}
