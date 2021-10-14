//
//  AmountComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 14/10/21.
//

import Foundation
import UIKit

class AmountComponent: AlchemistLiteUIComponent {
    private(set) static var componentType = "amount"

    var id: String
    var type: String
    var notificationHandler: AlchemistLiteNotificationHandler

    private(set) var content: Content
    private var currentView: AmountComponentView?

    required init(config: AlchemistLiteUIComponentConfiguration) throws {
        self.id = config.component.id
        self.type = config.component.type
        guard let componentData = config.component.content else { throw AlchemistLiteError.componentDataMissing(component: AmountComponent.componentType)}
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
        let view = AmountComponentView(viewModel: AmountComponentViewModel(build: AmountComponentViewModel.Build(content: content, notificationHandler: notificationHandler)))
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

extension AmountComponent {
    struct Content: Decodable, Equatable {
        let amountDisplayValue: String
        let amount: Double
        let currencySymbol: String
        let cardImage: String
        let cardType: String
    }
}
