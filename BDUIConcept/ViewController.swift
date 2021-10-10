//
//  ViewController.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1 - Register Components
        AlchemistLiteManager.registerComponent(AlchemistLiteRegistration(type: "fistType", onInitialization: { component in
            print("handle init")
            fatalError()
        }))
        
        AlchemistLiteManager.registerComponent(AlchemistLiteRegistration(type: "secondType", onInitialization: { component in
            print("handle init")
            fatalError()
        }))
        
        guard let bundlePath = Bundle.main.path(forResource: "SDUIInitialDraft", ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
              let deserialized = try? JSONDecoder().decode([BEComponent].self, from: jsonData) else {
                  return
        }
        let d = 4
        print(deserialized)
    }


}

