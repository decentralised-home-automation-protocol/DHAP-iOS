//
//  DeviceViewController.swift
//  CocoaAsyncSocket
//
//  Created by Aiden Garipoli on 9/9/19.
//

import Foundation
import UIKit

open class DeviceViewController: UIViewController {
    
    var contentView: UIView?
    var scrollView: UIScrollView?
    
    open override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissActiveSelection))
        self.view.addGestureRecognizer(tapGesture)
        
        let scrollView = UIScrollView()
        self.scrollView = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let contentView = UIView()
        self.contentView = contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let heightConstraint = contentView.heightAnchor.constraint(equalTo:scrollView.heightAnchor)
        heightConstraint.priority = UILayoutPriority(rawValue: 250)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
        ])
        
        navigationController?.title = "Device"
        
        let xmlPath = Bundle.main.url(forResource: "ui", withExtension: ".xml")!
        
        let main = Main()
        main.getGroupElements(xmlPath: xmlPath) { (groupElements) in
            self.addGroupElementsToView(groupElements: groupElements)
        }
    }
    
    @objc private func dismissActiveSelection() {
        self.view.endEditing(true)
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
        
//        self.view.addSubview(stackView)
        self.contentView?.addSubview(stackView)
        
//        let guide = self.view.layoutMarginsGuide
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: guide.topAnchor)
//        ])
        guard let contentView = self.contentView else { return }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
}
