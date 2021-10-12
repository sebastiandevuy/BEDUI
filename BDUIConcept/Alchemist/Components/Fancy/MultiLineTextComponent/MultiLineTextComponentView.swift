//
//  MultiLineTextComponentView.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 12/10/21.
//

import Foundation
import UIKit

class MultiLineTextComponentView: UIView, AlchemistLiteViewUpdatable {
    private let titleLabel = UILabel()
    
    
    init(viewModel: MultiLineTextComponent.Content) {
        super.init(frame: .zero)
        titleLabel.text = viewModel.body
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                                     titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                                     titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)])
        
    }
    
    func update(withContent content: MultiLineTextComponent.Content) {
        titleLabel.text = content.body
    }
}
