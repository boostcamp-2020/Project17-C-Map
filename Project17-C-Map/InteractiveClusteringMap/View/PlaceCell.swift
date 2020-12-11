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
        super.prepareForReuse()
        self.imageView.image = #imageLiteral(resourceName: "defaultImg")
        self.category.text = ""
        self.name.text = ""
        self.address.text = ""
    }
    
    func configure(place: Place) {
        self.category.text = place.info.category
        self.name.text = place.info.name
        self.address.text = place.info.imageUrl
    }
    
    func configure(image: UIImage?) {
        self.imageView.image = image
    }
    
    func configure(address: String) {
        self.address.text = address
    }
    
}
