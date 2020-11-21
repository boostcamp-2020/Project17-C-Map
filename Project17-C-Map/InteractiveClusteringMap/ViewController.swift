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
    
        let context = CoreDataStack.context
        
        let entity = NSEntityDescription.entity(forEntityName: "POI", in: context)
        if let entity = entity {
            let poi = NSManagedObject(entity: entity, insertInto: context)
            poi.setValue(30.173648, forKey: "x")
            poi.setValue(120.182837, forKey: "y")
            let poi2 = NSManagedObject(entity: entity, insertInto: context)
            poi2.setValue(33.3178, forKey: "x")
            poi2.setValue(127.782837, forKey: "y")
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            let contact = try context.fetch(POI.fetchRequest()) as! [POI]
            contact.forEach {
                print($0.x, $0.y)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
