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
    
    private let assetImageStrings = [["main"],
                              ["marker-short-touch-0",
                               "marker-short-touch-1"],
                              ["marker-long-touch-0",
                               "marker-long-touch-1"],
                              ["cluster-short-touch-0",
                               "cluster-short-touch-1"],
                              ["cluster-long-touch-0",
                               "cluster-long-touch-1"],
                              ["map-long-touch-0",
                               "map-long-touch-1",
                               "map-long-touch-2"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureRootViewBackgroundColor()
    }
    
    func configureRootViewBackgroundColor() {
        let gradient = CAGradientLayer()
        
        gradient.frame = view.frame
        gradient.colors = [UIColor.greenCyan.cgColor, UIColor.deepBlue.cgColor]
        
        view.layer.insertSublayer(gradient, at: .zero)
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
        onboardCell.configure(imageStrings: assetImageStrings[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? OnboardCollectionViewCell else {
            return
        }
        cell.animate()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardPageControl.numberOfPages = assetImageStrings.count
        return assetImageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardCollectionView.frame.width, height: onboardCollectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.onboardPageControl.currentPage = Int(targetContentOffset.pointee.x / onboardCollectionView.frame.width)
    }
    
}
