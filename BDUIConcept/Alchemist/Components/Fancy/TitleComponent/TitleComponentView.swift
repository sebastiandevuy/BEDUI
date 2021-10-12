//
//  TitleComponentView.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 12/10/21.
//

import UIKit

class TitleComponentView: UIView, AlchemistLiteViewUpdatable {
    private let titleLabel = UILabel()
    private let viewModel: TitleComponentViewModel
    
    init(viewModel: TitleComponentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        viewModel.onTitleUpdated = { [weak self] in
            self?.titleLabel.text = self?.viewModel.title
        }
    }
    
    private func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = viewModel.title
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                                     titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                                     titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)])
        
    }
    
    func update(withContent content: TitleComponent.Content) {
        viewModel.update(content)
    }
}
