//
//  DataManagable.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

protocol DataManagable {
    
    func fetch()
    func save(successHandler: @escaping () -> Void, failureHandler: ((NSError) -> Void)?)
    func setValue()
    
}
