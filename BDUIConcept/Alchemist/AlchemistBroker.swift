//
//  AlchemistBroker.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

class AlchemistLiteBroker {
    private var currentSessionComponents = [AlchemistLiteUIComponent]()
    var onUpdatedViews: ((Result<[UIView], Error>) -> Void)?
    
    func load() {
        guard let bundlePath = Bundle.main.path(forResource: "SDUIInitialDraft", ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
              let deserialized = try? JSONDecoder().decode([BEComponent].self, from: jsonData) else {
                  onUpdatedViews?(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                  return
        }
        
        handleUpdatedResults(updated: deserialized)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onUpdatedViews?(.success(self.currentSessionComponents.map({$0.getView()})))
        }
    }
    
    func load2() {
        guard let bundlePath = Bundle.main.path(forResource: "SDUISecondDraft", ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
              let deserialized = try? JSONDecoder().decode([BEComponent].self, from: jsonData) else {
                  onUpdatedViews?(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                  return
        }
        
        handleUpdatedResults(updated: deserialized)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onUpdatedViews?(.success(self.currentSessionComponents.map({$0.getView()})))
        }
    }
    
    private func handleUpdatedResults(updated: [BEComponent]) {
        //1 - First time? just add´em up from registration
        if currentSessionComponents.count == 0 {
            for component in updated {
                guard let registration = AlchemistLiteManager.registeredComponents.first(where: {$0.type == component.type }),
                      let uiComponent = registration.onInitialization(component) else { continue }
                currentSessionComponents.append(uiComponent)
            }
            print("No previous components. Added server ones as default")
        } else {
            //2 - We need tp update and change locations
            var newComponentArray = [AlchemistLiteUIComponent]()
            
            //1 - get the id views on both sets and remove the ones that no longer apply
            let currentIds = currentSessionComponents.map({$0.id})
            let newIds = updated.map({$0.id})
            
            var idsToRemove = [String]()
            
            for id in currentIds {
                if !newIds.contains(id) {
                    idsToRemove.append(id)
                }
            }
            
            currentSessionComponents.removeAll(where: {idsToRemove.contains($0.id)})
            
            //2 - update current set while keeping old views
            for component in updated {
                if let currentComponent = currentSessionComponents.first(where: {$0.id == component.id}), let data = component.content {
                    if currentComponent.hash != component.hash {
                        print("Updating existing component with different hash")
                        DispatchQueue.main.async {
                            currentComponent.updateView(data: data)
                        }
                    } else {
                        print("Found component but with same hash. No updates done")
                    }
                    newComponentArray.append(currentComponent)
                } else {
                    guard let registration = AlchemistLiteManager.registeredComponents.first(where: {$0.type == component.type }),
                          let uiComponent = registration.onInitialization(component) else { continue }
                    newComponentArray.append(uiComponent)
                }
            }
            
            currentSessionComponents = newComponentArray
        }
    }
}