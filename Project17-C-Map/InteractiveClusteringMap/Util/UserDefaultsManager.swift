//
//  UserDefaultsManager.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/10.
//

import Foundation

protocol UserDefaultsManagable {
    
    var isLaunched: Bool { get set }
    
    init(userDefaults: UserDefaults)
    
}

final class UserDefaultsManager: UserDefaultsManagable {
    
    static let shared = UserDefaultsManager(userDefaults: .standard)
    
    private let userDefaults: UserDefaults
    private let firstLaunchKey: String = "com.boostcamp.mapc.InteractiveClusteringMap.WasLaunchedBefore"
    
    var isLaunched: Bool {
        get {
            userDefaults.bool(forKey: firstLaunchKey)
        } set {
            userDefaults.set(newValue, forKey: firstLaunchKey)
        }
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
}
