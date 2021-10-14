//
//  TitleComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 12/10/21.
//

import Foundation
import UIKit

class TitleComponent: AlchemistLiteUIComponent {
    private(set) static var componentType = "titleSingle"
    
    var id: String
    var type: String
    var notificationHandler: AlchemistLiteNotificationHandler
    
    private(set) var content: Content
    private var currentView: TitleComponentView?
    
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
        let view = TitleComponentView(viewModel: TitleComponentViewModel(content: content,
                                                                         handler: notificationHandler))
        currentView = view
        return view
    }
    
    func updateView(data: Data) {
        guard let updatedContent = try? JSONDecoder().decode(Content.self, from: data),
              updatedContent != self.content else {
                  print("No changes for \(TitleComponent.componentType)")
                  return
              }
        self.content = updatedContent
        currentView?.update(withContent: updatedContent)
    }
}

extension TitleComponent {
    struct Content: Decodable, Equatable {
        let title: String
    }
}
