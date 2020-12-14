//
//  PlaceHeaderView.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/09.
//

import UIKit

class PlaceHeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var category: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.category.text = ""
    }
    
    func configure(text: String) {
        self.category.text = text
    }
    
}
