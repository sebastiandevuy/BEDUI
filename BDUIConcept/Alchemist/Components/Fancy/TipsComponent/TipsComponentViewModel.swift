//
//  TipsComponentViewModel.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 14/10/21.
//

import Foundation

class TipsComponentViewModel: ViewModellable {
    let viewState = ViewState()
    let modelState: ModelState

    init(build: Build) {
        modelState = ModelState(notificationHandler: build.notificationHandler,
                                content: build.content)
    }

    func dispatchInputAction(_ action: InputAction) {
        switch action {
        case .didSetupView:
            handleDidSetupView()
        case .didUpdate(let content):
            handleDidUpdateContent(content)
        case .didTapAmount(let index):
            handleDidTapAmount(index)
        }
    }

    private func handleDidTapAmount(_ index: Int) {
        print(modelState.content.tips[index])
    }

    private func handleDidUpdateContent(_ content: TipsComponent.Content) {
        modelState.content = content
        handleDidSetupView()
    }

    private func handleDidSetupView() {
        viewState.tips.value = modelState.content.tips
    }
}

extension TipsComponentViewModel {
    class ViewState {
        let tips = StateObservable<[TipsComponent.Tip]>(nil)
    }

    class ModelState {
        let notificationHandler: AlchemistLiteNotificationHandler
        var content: TipsComponent.Content

        init(notificationHandler: AlchemistLiteNotificationHandler,
             content: TipsComponent.Content) {
            self.notificationHandler = notificationHandler
            self.content = content
        }
    }

    enum InputAction: Equatable {
        case didSetupView
        case didUpdate(content: TipsComponent.Content)
        case didTapAmount(index: Int)
    }
}

extension TipsComponentViewModel {
    struct Build {
        let content: TipsComponent.Content
        let notificationHandler: AlchemistLiteNotificationHandler
    }
}
