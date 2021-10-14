//
//  ViewModelable.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 14/10/21.
//

import Foundation

protocol ViewModellable {
    // Actions to be received by the controller in reponse to user input or events
    associatedtype InputAction: Equatable

    // Variables and observables related to the View
    associatedtype ViewState

    // Variables related to the model
    associatedtype ModelState

    func dispatchInputAction(_ action: InputAction)

    // Convention based. Views should never update viewstate or modelState
    var viewState: ViewState { get }
    var modelState: ModelState { get }
}

class StateObservable<T> {
    /// Closure to be called on state changes. Calls block on main thread.
    var bind: (T?) -> Void = { _ in }

    var value: T? {
        didSet {
            if Thread.isMainThread {
                bind(value)
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.bind(self.value)
                }
            }

        }
    }

    init(_ value: T?) {
        self.value = value
    }
}
