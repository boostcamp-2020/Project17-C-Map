//
//  FirstLaunchDetector.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/10.
//

import Foundation

final class FirstLaunchDetector {
    
    static let shared = FirstLaunchDetector(userDefaults: .standard)
    
    private let userDefaults: UserDefaults
    private let firstLaunchKey: String = "com.boostcamp.mapc.InteractiveClusteringMap.WasLaunchedBefore"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func isFirstLaunch() -> Bool {
        guard userDefaults.bool(forKey: firstLaunchKey) else {
            userDefaults.set(true, forKey: firstLaunchKey)
            return true
        }
        return false
    }
    
}
