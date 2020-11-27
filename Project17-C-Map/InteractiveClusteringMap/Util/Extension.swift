//
//  Extension.swift
//  InteractiveClusteringMap
//
//  Created by 박성민 on 2020/11/24.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
