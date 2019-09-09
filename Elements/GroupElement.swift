//
//  GroupElement.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

@IBDesignable class GroupElement: UIView {
    
    @IBInspectable var contentView: UIView!
    
    @IBInspectable @IBOutlet var label: UILabel!
    
    @IBInspectable @IBOutlet var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNIB()
    }
    
    func loadViewFromNIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        stackView.isUserInteractionEnabled = true
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
    
}
