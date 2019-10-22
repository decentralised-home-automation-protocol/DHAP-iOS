//
//  ElementView.swift
//  DHAP
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation

protocol CommandDelegate {
    func didSendCommand(_ sender: ElementView, command: String)
}

class ElementView: UIView {
    
    var groupId: Int!
    
    var elementId: Int!
    
    var contentView: UIView?
    
    var delegate: CommandDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
}

extension UIView {
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
