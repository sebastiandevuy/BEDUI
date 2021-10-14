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
                                content: build.content,
                                configuration: build.configuration)
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
        let selectedItem = modelState.content.tips[index]
        // Poder chequear los eventos y ver si para ese id hay algo y ejecutarlo
        guard let events = modelState.configuration?.events, let event = events.filter({$0.targetId == index+1}).first else { return }

        modelState.notificationHandler.broadcastNotification(notification: AlchemistLiteNotification(id: event.eventType, data: event.eventBody))
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
        let configuration: AlchemistLiteEventConfiguration?

        init(notificationHandler: AlchemistLiteNotificationHandler,
             content: TipsComponent.Content,
             configuration: AlchemistLiteEventConfiguration?) {
            self.notificationHandler = notificationHandler
            self.content = content
            self.configuration = configuration
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
        let configuration: AlchemistLiteEventConfiguration?
    }
}
