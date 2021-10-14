//
//  MultiLineTextComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 12/10/21.
//

import Foundation
import UIKit

class MultiLineTextComponent: AlchemistLiteUIComponent {
    private(set) static var componentType = "multilineText"
    
    var id: String
    var type: String
    var notificationHandler: AlchemistLiteNotificationHandler
    
    private(set) var content: Content
    private var currentView: MultiLineTextComponentView?
    
    required init(config: AlchemistLiteUIComponentConfiguration) throws {
        self.id = config.component.id
        self.type = config.component.type
        guard let componentData = config.component.content else { throw AlchemistLiteError.componentDataMissing(component: TitleComponent.componentType)}
        do {
            self.content = try JSONDecoder().decode(Content.self, from: componentData)
        } catch {
            throw AlchemistLiteError.componentDataParsing(component: TitleComponent.componentType)
        }
        self.notificationHandler = config.notificationHandler
    }
    
    func getView() -> UIView {
        if let viewtoReturn = currentView {
            return viewtoReturn
        }
        let view = MultiLineTextComponentView(viewModel: content, handler: notificationHandler)
        currentView = view
        return view
    }
    
    func updateView(data: Data) {
        guard let updatedContent = try? JSONDecoder().decode(Content.self, from: data),
        updatedContent != self.content else {
            print("No changes for \(MultiLineTextComponent.componentType)")
            return
        }
        self.content = updatedContent
        currentView?.update(withContent: updatedContent)
    }
}

extension MultiLineTextComponent {
    struct Content: Decodable, Equatable {
        let body: String
    }
}
