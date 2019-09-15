//
//  SchedularElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 15/9/19.
//

import Foundation

class SchedularElement: ElementView {
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var taskSelection: UITextField!
    
    @IBOutlet var timeSelection: UITextField!

    @IBOutlet var submitButton: UIButton!
    
    var pickerView: UIPickerView?
    var timePickerView: UIDatePicker?
    
    var activeTextField: UITextField?
    
    var data = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // do element specific init here
        pickerView = UIPickerView()
        
        timePickerView?.datePickerMode = .time
        
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        taskSelection.inputView = pickerView
        timeSelection.inputView = timePickerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        print("submit schedular")
    }
}

extension SchedularElement: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
//        activeTextField?.text = data[row]
    }
    
}

//extension SchedularElement: UITextFieldDelegate {
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        activeTextField = textField
//
//        if textField == timeSelection {
////            pickerView.
//        }
//
//        return true
//    }
//
//}
