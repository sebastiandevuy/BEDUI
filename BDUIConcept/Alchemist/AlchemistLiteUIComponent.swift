//
//  AlchemistLiteUIComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

protocol AlchemistLiteUIComponent {
    var id: String { get }
    var hash: String { get }
    var type: String { get }
    func getView() -> UIView
    func updateView(data: Data)
}
