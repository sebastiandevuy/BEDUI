//
//  AmountComponentView.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 14/10/21.
//

import UIKit
import SDWebImage

class AmountComponentView: UIView, AlchemistLiteViewUpdatable {
    private let viewModel: AmountComponentViewModel
    private let cardImage = UIImageView()
    private let cardLabel = UILabel()
    private let amountLabel = UILabel()

    init(viewModel: AmountComponentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
        viewModel.dispatchInputAction(.didSetupView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBindings() {
        viewModel.viewState.paymentType.bind = { [weak self] paymentType in
            guard let self = self else { return }
            self.cardLabel.text = paymentType
        }

        viewModel.viewState.amount.bind = { [weak self] amount in
            guard let self = self else { return }
            self.amountLabel.text = amount
        }

        viewModel.viewState.cardLink.bind = { [weak self] link in
            guard let self = self, let link = link else { return }
            self.cardImage.sd_setImage(with: URL(string: link)!, completed: nil)
        }
    }

    private func setupView() {
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardImage)
        NSLayoutConstraint.activate([cardImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                                     cardImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     cardImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                                     cardImage.heightAnchor.constraint(equalToConstant: 24),
                                     cardImage.widthAnchor.constraint(equalToConstant: 48)])

        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardLabel)
        NSLayoutConstraint.activate([cardLabel.centerYAnchor.constraint(equalTo: cardImage.centerYAnchor),
                                     cardLabel.leftAnchor.constraint(equalTo: cardImage.rightAnchor, constant: 8)])

        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(amountLabel)
        NSLayoutConstraint.activate([amountLabel.centerYAnchor.constraint(equalTo: cardLabel.centerYAnchor),
                                     amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)])
    }

    func update(withContent: AmountComponent.Content) {
        viewModel.dispatchInputAction(.didUpdate(content: withContent))
    }

}
