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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(SDUITestViewController(), animated: true, completion: nil)
    }
}

