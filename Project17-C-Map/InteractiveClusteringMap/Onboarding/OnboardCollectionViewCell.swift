//
//  OnboardCollectionViewCell.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/13.
//

import UIKit

class OnboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var onboardImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var imageStrings: [String]?
    var nextButtonTapped: (() -> Void)?
    var currentImageString: String?
    
    func configure(imageStrings: [String]) {
        self.imageStrings = imageStrings
        onboardImage.image = UIImage(named: imageStrings.first ?? "")
        currentImageString = imageStrings.first
    }
    
    func animate() {
        guard let imageStrings = imageStrings,
              let currentImageString = currentImageString,
              let currentIndex = imageStrings.firstIndex(of: currentImageString) else {
            return
        }
        let nextIndex = (currentIndex < imageStrings.count - 1) ? currentIndex + 1 : 0
        let currentImage = UIImage(named: currentImageString)
        let nextImage = UIImage(named: imageStrings[nextIndex])
       
        let animation = CABasicAnimation(keyPath: "contents")
        
        animation.fromValue = currentImage?.cgImage
        animation.toValue = nextImage?.cgImage
        animation.duration = 1
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.onboardImage.image = nextImage
            self.currentImageString = imageStrings[nextIndex]
        }
        self.onboardImage.layer.add(animation, forKey: "imageTransform")
        CATransaction.commit()
    }
    
}
