//
//  OnboardingViewController.swift
//  InteractiveClusteringMap
//
//  Created by Oh Donggeon on 2020/12/10.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardCollectionView: UICollectionView!
    @IBOutlet weak var onboardPageControl: UIPageControl!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    private let assetImagesString: [String] = ["onboard0",
                                               "onboard0",
                                               "onboard0",
                                               "onboard0",
                                               "onboard0",
                                               "onboard0",
                                               "onboard0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func skipButtonTouched(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        onboardCollectionView.selectItem(at: IndexPath(item: sender.currentPage, section: 0),
                                         animated: true,
                                         scrollPosition: .centeredHorizontally)
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath)
        guard let onboardCell = cell as? OnboardCollectionViewCell else {
            return cell
        }
        onboardCell.onboardImage.image = UIImage(named: assetImagesString[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardPageControl.numberOfPages = assetImagesString.count
        return assetImagesString.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardCollectionView.frame.width, height: onboardCollectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.onboardPageControl.currentPage = Int(targetContentOffset.pointee.x / onboardCollectionView.frame.width)
    }
    
}
