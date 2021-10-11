//
//  AlchemistLiteManager.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

class AlchemistLiteManager {
    private init() {}
    static let shared = AlchemistLiteManager()
    
    private(set) static var registeredComponents: [AlchemistLiteRegistration] = []
    
    /// Registers components to be turned into AlchemistLiteUIComponents
    /// - Parameter registration: Information needed to create this components
    static func registerComponent(_ registration: AlchemistLiteRegistration) {
        guard registeredComponents.first(where: {$0.type == registration.type}) == nil else {
            return
        }
        registeredComponents.append(registration)
    }
    
    func getViewBroker() -> AlchemistLiteBroker {
        return AlchemistLiteBroker()
    }
}

class AlchemistLiteBroker {
    private var currentSessionComponents = [AlchemistLiteUIComponent]()
    var updates: ((Result<[UIView], Error>) -> Void)?
    
    func listenViewUpdates(completion: @escaping (Result<[UIView], Error>) -> Void ) {
        // Get views from repo or whatever
        guard let bundlePath = Bundle.main.path(forResource: "SDUIInitialDraft", ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
              let deserialized = try? JSONDecoder().decode([BEComponent].self, from: jsonData) else {
                  completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                  return
        }
        
        let parsedComponents = parseComponentsFromResponse(deserialized)
        handleUpdatedResults(updated: parsedComponents)
        completion(.success(currentSessionComponents.map({$0.getView()})))
    }
    
    func load() {
        
    }
    
    private func parseComponentsFromResponse(_ response: [BEComponent]) -> [AlchemistLiteUIComponent] {
        var componentsResponse = [AlchemistLiteUIComponent]()
        for component in response {
            guard let registration = AlchemistLiteManager.registeredComponents.first(where: {$0.type == component.type }),
            let uiComponent = registration.onInitialization(component) else { continue }
            componentsResponse.append(uiComponent)
        }
        return componentsResponse
    }
    
    private func handleUpdatedResults(updated: [AlchemistLiteUIComponent]) {
        //Perform updates
        
        //1 - First time? just add´em up
        if currentSessionComponents.count == 0 {
            currentSessionComponents = updated
            print("No previous components. Added server ones as default")
        } else {
            //2 - We need tp update and change locations
            var newComponentArray = [AlchemistLiteUIComponent]()
            
            //First get the id of current views
            let currentIds = currentSessionComponents.map({$0.id})
            let newIds = updated.map({$0.id})
            
            var idsToRemove = [String]()
            
            newIds.forEach({ identity in
                if !currentIds.contains(identity) {
                    idsToRemove.append(identity)
                }
            })
            
            currentSessionComponents.removeAll(where: {idsToRemove.contains($0.id)})
            
            //Clean previous ones
            
        }
    }
}

struct AlchemistLiteRegistration {
    let type: String
    let onInitialization: ((BEComponent) -> AlchemistLiteUIComponent?)
}

protocol AlchemistLiteUIComponent {
    var id: String { get }
    var hash: String { get }
    var type: String { get }
    func getView() -> UIView
    func updateView(data: Data)
}

protocol AlchemistLiteViewable where Self: UIView {
    associatedtype Content
    func update(withContent: Content)
}

class Component1: AlchemistLiteUIComponent {
    var id: String
    var hash: String
    var type: String
    var data: ModelData
    
    private var currentView: UIView?
    
    init(id: String, hash: String, type: String, data: Data?) throws {
        self.id = id
        self.hash = hash
        self.type = type
        guard let content = data else { throw NSError(domain: "", code: 123, userInfo: nil)}
        self.data = try JSONDecoder().decode(ModelData.self, from: content)
        print(self.data)
    }
    
    func getView() -> UIView {
        if let viewtoReturn = currentView {
            return viewtoReturn
        }
        let view = UIView()
        currentView = view
        view.backgroundColor = .yellow
        NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 200)])
        return view
    }
    
    func updateView(data: Data) {
        fatalError()
    }
    
    struct ModelData: Decodable {
        let name: String
        let age: Int
    }
}

class Component2: AlchemistLiteUIComponent {
    var id: String
    var hash: String
    var type: String
    var data: ModelData
    
    init(id: String, hash: String, type: String, data: Data?) throws {
        self.id = id
        self.hash = hash
        self.type = type
        guard let content = data else { throw NSError(domain: "", code: 123, userInfo: nil)}
        self.data = try JSONDecoder().decode(ModelData.self, from: content)
        print(self.data)
    }
    
    func getView() -> UIView {
        let view = UIView()
        view.backgroundColor = .blue
        NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 300)])
        return view
    }
    
    func updateView(data: Data) {
        fatalError()
    }
    
    struct ModelData: Decodable {
        let isTrue: Bool
        let title: String
    }
}

class Component3: AlchemistLiteUIComponent {
    var id: String
    var hash: String
    var type: String
    var data: ModelData

    init(id: String, hash: String, type: String, data: Data?) throws {
        self.id = id
        self.hash = hash
        self.type = type
        guard let content = data else { throw NSError(domain: "", code: 123, userInfo: nil)}
        self.data = try JSONDecoder().decode(ModelData.self, from: content)
        print(self.data)
    }

    func getView() -> UIView {
        let view = UIView()
        view.backgroundColor = .blue
        NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: 300)])
        return view
    }

    func updateView(data: Data) {
        fatalError()
    }

    struct ModelData: Decodable {
        let year: Int
    }
}
