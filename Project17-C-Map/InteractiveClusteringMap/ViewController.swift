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
        
//        do {
//            try CoreDataStack.shared.save()
//        } catch {
//            print(error.localizedDescription)
//        }
        
        CoreDataStack.shared.save() {
            print("Success")
        }
        
//        do {
//            let contact = try context.fetch(POI.fetchRequest()) as! [POI]
//            contact.forEach {
//                print($0.x, $0.y)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
    }
    
}
