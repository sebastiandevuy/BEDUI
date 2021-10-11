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
    
    /// Notifies subscriber of the status of obtaining or refreshing views
    var onUpdatedViews: ((Result<[UIView], AlchemistLiteError>) -> Void)?
    
    func load() {
        guard let bundlePath = Bundle.main.path(forResource: "SDUIInitialDraft", ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
              let deserialized = try? JSONDecoder().decode([BEComponent].self, from: jsonData) else {
                  onUpdatedViews?(.failure(.responseDeserialization))
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
                  onUpdatedViews?(.failure(.responseDeserialization))
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
        if currentSessionComponents.isEmpty {
            for component in updated {
                guard let registration = AlchemistLiteManager.registeredComponents.first(where: {$0.type == component.type }),
                      let uiComponent = registration.onInitialization(component) else {
                          // Log this somewhere
                          continue
                      }
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
                          let uiComponent = registration.onInitialization(component) else {
                              // Log this somewhere
                              continue
                          }
                    newComponentArray.append(uiComponent)
                }
            }
            
            currentSessionComponents = newComponentArray
        }
    }
}

extension AlchemistLiteBroker {
    enum LoadType {
        // To get response from local json file. Use file name without extension.
        case fromLocalFile(name: String, bundle: Bundle)
        
        // URL to make remote request for components
        case fomUrl(url: URL)
        
        // If using a mixed response, just provide those BE components for evaluation.
        case fromProvidedComponents(components: BEComponent)
    }
}
