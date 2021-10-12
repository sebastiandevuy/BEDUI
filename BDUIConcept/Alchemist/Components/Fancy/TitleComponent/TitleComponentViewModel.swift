//
//  TitleComponentViewModel.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 12/10/21.
//

import Foundation

class TitleComponentViewModel {
    private(set) var title: String
    
    var onTitleUpdated: (() -> Void)?
    
    init(content: TitleComponent.Content) {
        self.title = content.title
    }
    
    func update(_ content: TitleComponent.Content) {
        title = content.title
        onTitleUpdated?()
    }
}
