//
//  FilterButton.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/11.
//

import UIKit

final class FilterButton: UIButton {
    
    func configure(text: String) {
        let color: UIColor = .systemRed
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal)
        layer.borderColor =  color.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 15
        backgroundColor = .systemBackground
        contentEdgeInsets = UIEdgeInsets.init(top: 3, left: 10, bottom: 3, right: 10)
    }
    
}
