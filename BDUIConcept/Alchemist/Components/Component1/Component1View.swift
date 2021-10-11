//
//  Component1View.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import UIKit

class Component1View: UIView, AlchemistLiteViewable {
    private var data: Component1.ModelData
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    
    init(component: Component1.ModelData) {
        data = component
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withContent content: Component1.ModelData) {
        nameLabel.text = content.name
        ageLabel.text = String(content.age)
    }
    
    private func setupView() {
        backgroundColor = .red
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.text = data.name
        addSubview(nameLabel)
        NSLayoutConstraint.activate([nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)])
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.text = String(data.age)
        ageLabel.textColor = .white
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ageLabel)
        
        NSLayoutConstraint.activate([ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
                                     ageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)])
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tappedView))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tappedView() {
        ageLabel.font = UIFont.boldSystemFont(ofSize: 36)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 36)
    }
}
