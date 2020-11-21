//
//  ViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/16.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CoreDataStack.shared.fetch())
    }
    
}
