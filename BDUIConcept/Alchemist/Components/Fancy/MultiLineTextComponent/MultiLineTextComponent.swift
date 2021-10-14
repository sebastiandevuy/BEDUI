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
    
    private(set) var content: Content
    private var currentView: MultiLineTextComponentView?
    
    required init(component: BEComponent) throws {
        self.id = component.id
        self.type = component.type
        guard let componentData = component.content else { throw AlchemistLiteError.componentDataMissing(component: TitleComponent.componentType)}
        do {
            self.content = try JSONDecoder().decode(Content.self, from: componentData)
        } catch {
            throw AlchemistLiteError.componentDataParsing(component: TitleComponent.componentType)
        }
    }
    
    func getView() -> UIView {
        if let viewtoReturn = currentView {
            return viewtoReturn
        }
        let view = MultiLineTextComponentView(viewModel: content)
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
