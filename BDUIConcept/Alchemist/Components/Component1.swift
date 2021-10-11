//
//  Component1.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

class Component1: AlchemistLiteUIComponent {
    var id: String
    var hash: String
    var type: String
    var data: ModelData
    
    private var currentView: UIView?
    
    init(id: String, hash: String, type: String, data: Data?) throws {
        self.id = id
        self.hash = hash
        self.type = type
        guard let content = data else { throw NSError(domain: "", code: 123, userInfo: nil)}
        self.data = try JSONDecoder().decode(ModelData.self, from: content)
        print(self.data)
    }
    
    func getView() -> UIView {
        if let viewtoReturn = currentView {
            return viewtoReturn
        }
        let view = UIView()
        currentView = view
        view.backgroundColor = .yellow
        NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 200)])
        return view
    }
    
    func updateView(data: Data) {
        fatalError()
    }
    
    struct ModelData: Decodable {
        let name: String
        let age: Int
    }
}
