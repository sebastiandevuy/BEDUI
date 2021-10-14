//
//  AlchemistLiteUIComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

protocol AlchemistLiteUIComponent {
    // Component id to be used by Alchemist Lite
    static var componentType: String { get }
    
    var id: String { get }
    var type: String { get }
    var notificationHandler: AlchemistLiteNotificationHandler { get }
    
    func getView() -> UIView
    func updateView(data: Data)
    
    init(config: AlchemistLiteUIComponentConfiguration) throws
}
