//
//  SDUITestViewController.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import UIKit

class SDUITestViewController: UIViewController {
    private var broker: AlchemistLiteBroker!
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //1 - Register Components
        AlchemistLiteManager.registerComponent(AlchemistLiteRegistration(type: TitleComponent.componentType, onInitialization: { component in
            return try? TitleComponent(component: component)
        }))
        
        AlchemistLiteManager.registerComponent(AlchemistLiteRegistration(type: ImageCarrouselComponent.componentType, onInitialization: { component in
            return try? ImageCarrouselComponent(component: component)
        }))
        
        
        //2 - Obtain a broker - Probably with params in order to set the endpoint to be called. TBD
        broker = AlchemistLiteManager.shared.getViewBroker()
        
        broker.onUpdatedViews = { [weak self] result in
            switch result {
            case .success(let views):
                self?.handleViewAnimation(forViews: views)
            case .failure(let error):
                print(error)
            }
        }
        
        broker.load()
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 10) { [weak self] in
            self?.broker.load2()
        }
    }
    
    func handleViewAnimation(forViews views: [UIView]) {
        DispatchQueue.main.async { [weak self] in
            self?.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            views.forEach({ self?.stackView.addArrangedSubview($0) })
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     stackView.rightAnchor.constraint(equalTo: view.rightAnchor)])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        print("WE HAVE NO LEAKS!!!")
    }

}
