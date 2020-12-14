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
    
    var isLaunched: Bool {
        get {
            userDefaults.bool(forKey: firstLaunchKey)
            return false
        } set {
            userDefaults.set(newValue, forKey: firstLaunchKey)
        }
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
}
