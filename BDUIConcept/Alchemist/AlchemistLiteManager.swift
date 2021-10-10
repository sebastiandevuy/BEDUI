//
//  AlchemistLiteManager.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

class AlchemistLiteManager {
    private static var registeredComponents: [AlchemistLiteRegistration] = []
    
    static func registerComponent(_ registration: AlchemistLiteRegistration) {
        guard registeredComponents.first(where: {$0.type == registration.type}) == nil else {
            return
        }
        registeredComponents.append(registration)
    }
}

struct AlchemistLiteRegistration {
    let type: String
    let onInitialization: ((BEComponent) -> AlchemistLiteUIComponent)
}

protocol AlchemistLiteUIComponent {
    var id: String { get }
    func getView() -> UIView
    func updateView(data: Data)
}
