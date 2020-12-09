//
//  PlaceCell.swift
//  InteractiveClusteringMap
//
//  Created by Seungeon Kim on 2020/12/09.
//

import UIKit

class PlaceCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var category: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var address: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    func configure(place: Place = Place(coordinate: Coordinate(x: 0, y: 0), info: POIInfo(name: "11", imageUrl: "11", category: "1"))) {
        self.category.text = place.info.category
        self.name.text = place.info.name
        self.address.text = place.info.imageUrl
    }
    
}
