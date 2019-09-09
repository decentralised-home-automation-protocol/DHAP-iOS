//
//  GUIElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

public enum GUIElementType: String {
    
    case toggle, spinner, progress
    
}

public struct GUIElement {
    
    public var type: GUIElementType
    
    public var label: String
    
}
