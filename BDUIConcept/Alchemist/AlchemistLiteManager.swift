//
//  AlchemistLiteManager.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

class AlchemistLiteManager {
    private init() {}
    static let shared = AlchemistLiteManager()
    
    private(set) static var registeredComponents: [AlchemistLiteRegistration] = []
    
    /// Registers components to be turned into AlchemistLiteUIComponents
    /// - Parameter registration: Information needed to create this components
    static func registerComponent(_ registration: AlchemistLiteRegistration) {
        guard registeredComponents.first(where: {$0.type == registration.type}) == nil else {
            return
        }
        registeredComponents.append(registration)
    }
    
    func getViewBroker() -> AlchemistLiteBroker {
        return AlchemistLiteBroker()
    }
}

protocol AlchemistLiteViewable where Self: UIView {
    associatedtype Content
    func update(withContent: Content)
}
