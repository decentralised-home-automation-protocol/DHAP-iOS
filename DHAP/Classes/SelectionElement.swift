//
//  SelectionElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 13/9/19.
//

import Foundation
import UIKit

class SelectionElement: ElementView {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var selectionField: UITextField!
    
    var pickerView: UIPickerView?
    
    // temp
    var data = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // do element specific init here
        pickerView = UIPickerView()
        
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        selectionField.inputView = pickerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SelectionElement: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionField.text = data[row]
    }
    
}
