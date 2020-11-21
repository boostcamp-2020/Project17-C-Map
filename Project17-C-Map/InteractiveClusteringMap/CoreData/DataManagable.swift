//
//  DataManagable.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/11/21.
//

import Foundation

protocol DataManagable {
    
    func fetch() -> [POI]
    func save(successHandler: @escaping () -> Void, failureHandler: ((NSError) -> Void)?)
    func setValue(_ poi: POI)
    
}
