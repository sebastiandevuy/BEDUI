//
//  TipsComponentView.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 14/10/21.
//

import UIKit

class TipsComponentView: UIView, AlchemistLiteViewUpdatable {
    private let stackView = UIStackView()
    private let viewModel: TipsComponentViewModel

    init(viewModel: TipsComponentViewModel) {
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
        viewModel.viewState.tips.bind = { [weak self] tips in
            guard let self = self, let tips = tips else { return }
            self.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            for (index, tip) in tips.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(tip.displayValue, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)
                self.stackView.addArrangedSubview(button)
            }
        }
    }

    @objc
    private func didTapButton(_ button: UIButton) {
        viewModel.dispatchInputAction(.didTapAmount(index: button.tag))
    }

    private func setupView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                                     stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                     stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                                     stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
                                     stackView.heightAnchor.constraint(equalToConstant: 48)])
    }

    func update(withContent: TipsComponent.Content) {
        viewModel.dispatchInputAction(.didUpdate(content: withContent))
    }
}
