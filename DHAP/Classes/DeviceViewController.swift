//
//  DeviceViewController.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation
import UIKit

open class DeviceViewController: UIViewController {
    
    open override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "Device"
        
        let xmlPath = Bundle.main.url(forResource: "ui", withExtension: ".xml")!
        
        let main = Main()
        main.getGroupElements(xmlPath: xmlPath) { (groupElements) in
            self.addGroupElementsToView(groupElements: groupElements)
        }
    }
    
    private func addGroupElementsToView(groupElements: [GroupElement]) {
        let stackView = UIStackView(arrangedSubviews: groupElements)
        stackView.backgroundColor = .red
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = true
        
        self.view.addSubview(stackView)
        
        let guide = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: guide.topAnchor)
        ])
    }
    
}
