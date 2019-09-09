//
//  ButtonToggleElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

@IBDesignable class ButtonToggleElement: UIView {
    
    @IBInspectable var contentView: UIView!
    
    @IBInspectable @IBOutlet var label: UILabel!
    
    @IBInspectable @IBOutlet var button: UIButton!
    
    // for using ButtonToggleElement in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNIB()
    }
    
    // for using ButtonToggleElement in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNIB()
    }
    
    func loadViewFromNIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.isUserInteractionEnabled = true
        
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadViewFromNIB()
        contentView?.prepareForInterfaceBuilder()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("button pressed")
    }
    
}
