//
//  OnboardingViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/10.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardCollectionViewCell: UICollectionView!
    @IBOutlet weak var onboardPageControl: UIPageControl!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func skipButtonTouched(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardPageControl.numberOfPages = 3
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath)
    }
    
}
